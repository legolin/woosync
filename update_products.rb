require 'csv'
require "woocommerce_api"
require 'hashdiff'

# Update attributes for a product

csv_path = ARGV[0]
file = File.read(csv_path)
csv = CSV.parse(file, headers: true)


@woo = WooCommerce::API.new(
  "https://salomefurnishings.com",
  ENV['WOOCOMMERCE_API_KEY'],
  ENV['WOOCOMMERCE_API_SECRET'],
  {
    wp_api: true,
    version: "wc/v3"
  }
)

# Get all the products until no more products are returned.
@all_products = []
page_size = 100

1.upto(100) do |n|
  puts "Fetching products #{(n - 1) * page_size} to #{n * page_size}..."

  batch = @woo.get('products', page: n, per_page: page_size, context: 'edit').parsed_response

  @all_products += batch

  break if batch.length < page_size
end

@category_ids_by_slug =
  @woo.get('products/categories', page: 1, per_page: 100)
  .parsed_response
  .each_with_object({}) do |cat, hash|
    hash[cat['slug']] = cat['id']
  end

@tag_ids =
  @woo.get('products/tags', page: 1, per_page: 100)
  .parsed_response
  .each_with_object({}) do |tag, hash|
    hash[tag['slug']] = tag['id']
  end

# Given an attributes array, update the given attribute with the new value
def update_attributes(attributes, name:, val:)
  if val.to_s == ''
    puts "Missing return policy code"
    return
  end

  if existing = attributes.find { _1['name'] == name}
    existing['options'] = [val]
  else
    attributes << { 'name' => name, 'options' => [val] }
  end
end

# Return "published" if the item is in stock and is a HomeRoots product
def status_for_row(row)
  return 'draft' unless (
    row['Quantity In Stock'].to_i > 0 && row['Title'].to_s.split(/\s+/).count >= 2
  )

  return 'publish'
end

def save_batch(updates:, to_create:)
  raise("Too many to save, limit is 100") if (updates.length + to_create.length) > 100

  res = @woo.post("products/batch", { update: updates, create: to_create })
  case res.code
  when 200
    puts 'Saved batch!'
  else
    puts "Error: #{res.code}"
  end
end

def lookup_product_by_sku(sku)
  @all_products.find { _1['sku'] == sku }
end

# Given a slug, create a new category with
# the slug as the name, and return the ID.
def create_category(slug, parent_slug:)
  puts "Slug: #{slug}, parent: #{parent_slug}, parent_id: #{@category_ids_by_slug[parent_slug]}"
  data = {
    name: slug,
    slug: slug,
  }
  data[:parent] = @category_ids_by_slug[parent_slug] if parent_slug

  res = @woo.post("products/categories", data).parsed_response
  res['id']
end

# Given a tag, create a new tag in Woocommerce with
# the slug as the slug, and return the ID.
def create_tag(slug)
  puts "Slug: #{slug}, parent: #{parent_slug}, parent_id: #{@category_ids_by_slug[parent_slug]}"
  data = {
    name: slug,
    slug: slug
  }

  res = @woo.post("products/tags", data).parsed_response
  res['id']
end

def category_ids(row)
  slugs = %w[Category Subcategory1 Subcategory2].map { row[_1] }.reject{ |slug| slug.nil? || slug == '' }.map(&:downcase)
  prev_slug = nil
  all_slugs = 0.upto(slugs.length - 1).map do |n|
    hash = {slug: slugs[0..n].join('-'), parent: prev_slug}
    prev_slug = hash[:slug]
    hash
  end.uniq

  ids = all_slugs.map do |hash, i|
    slug = hash[:slug]
    if id = @category_ids_by_slug[slug]
      id
    else
      id = create_category(slug, parent_slug: hash[:parent])
      @category_ids_by_slug[slug] = id
      id
    end
  end.map { { 'id' => _1} }
end

def tag_ids(row)
  return [] if row['Tags'].to_s == ''
  tags = row['Tags'].split(',').map { _1.strip }.reject{ |slug| slug.nil? || slug == '' }.map(&:downcase)

  return [] if tags.empty?

  ids = tags.map do |tag|
    if id = @tag_ids[tag]
      id
    else
      puts "creating tag #{tag}"
      id = create_tag(tag)
      @tag_ids[slug] = id
      id
    end
  end.map { { 'id' => _1} }
end

@updates = []
@to_create = []

# For each row, find the product and update it
csv.each do |row|
  sku = row['SKU']

  # Get the product
  product = lookup_product_by_sku(sku)

  attributes = if product.nil?
    []
  else
    product['attributes'].dup
  end

  update_attributes(attributes, name: 'Returns', val: row['ReturnPolicyCode'])

  data = {
    'status' => status_for_row(row),
    'regular_price' => row['MSRP'],
    'manage_stock' => true,
    'stock_quantity' => row['Quantity In Stock'].to_i,
    'attributes' => attributes,
    'categories' => category_ids(row),
    'dimensions' => {
      'length' => row['Product Depth'],
      'width' => row['Product Width'],
      'height' => row['Product Height']
    },
    'tags' => tag_ids(row),
    'name' => row['Title'],
    'description' => row['Description'],
  }

  if product.nil?
    @to_create << data.merge(
      'type' => 'simple',
      'sku' => sku,
      'images' => row['Images'].split(',').map { |url| { 'src' => url } },
    )
  else
    # Compare the new data with the existing data
    diff = Hashdiff.diff(
      product.slice('status', 'regular_price', 'stock_quantity', 'attributes', 'dimensions', 'name', 'description'),
      data.slice('status', 'regular_price', 'stock_quantity', 'attributes', 'dimensions', 'name', 'description')
    )
    changed_category_ids = (data['categories'].map{ _1['id'] } & product['categories'].map{ _1['id'] }).length != data['categories'].length
    if diff.length > 0 || changed_category_ids
      puts "#{sku}: #{diff.inspect}"
      @updates << data.merge(id: product['id'])
    end
  end

  # Save updates in batdches of 50
  if (@updates.length + @to_create.length) >= 50 || (@to_create.length > 10)
    puts "saving batch... #{@to_create.length} new, #{@updates.length} existing"
    save_batch(updates: @updates, to_create: @to_create)
    @updates = []
    @to_create = []
  end
end

# Save the remaining updates
save_batch(updates: @updates, to_create: @to_create) if @updates.any? || @to_create.any?


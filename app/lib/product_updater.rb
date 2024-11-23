require "csv"

def perform(csv_path)
  file = File.read(csv_path)
  csv = CSV.parse(file, headers: true)


  # @woo = WooCommerce::API.new(
  #   "https://salomefurnishings.com",
  #   Rails.application.credentials.dig(:woo_api, :key),
  #   Rails.application.credentials.dig(:woo_api, :secret),
  #   {
  #     wp_api: true,
  #     version: "wc/v3"
  #   }
  # )

# Update attributes for a product
class ProductUpdater
  include CableReady::Broadcaster

  # Given a Product instance, sync it to WooCommerce
  def perform(product)

    # Get the copy of this product from Woo
    remote_product = begin
      Model::Product.get_product_by_sku(product.sku)
    rescue Model::Product::NotFoundError
      nil
    end

    # attributes = if product.nil?
    #   []
    # else
    #   product["attributes"].dup
    # end

    # update_attributes(attributes, name: "Returns", val: product.return_policy_code)


      data = {
        "status" => status_for_row(row),
        "regular_price" => product.msrp,
        "manage_stock" => true,
        "stock_quantity" => product.quantity_in_stock,
        # "attributes" => attributes,
        "categories" => category_ids(product),
        "dimensions" => {
          "length" => product.length,
          "width" => product.width,
          "height" => product.height
        },
        "tags" => tag_ids(product),
        "name" => product.title,
        "description" => product.description
      }

      if product.nil?
        data.merge!(
          "type" => "simple",
          "sku" => product.sku,
          "images" => product.images.map { |image| { "src" => image.url } },
        )
      else
        # Compare the new data with the existing data
        diff = Hashdiff.diff(
          product.slice("status", "regular_price", "stock_quantity", "attributes", "dimensions", "name", "description"),
          data.slice("status", "regular_price", "stock_quantity", "attributes", "dimensions", "name", "description")
        )
        changed_category_ids = (data["categories"].map { _1["id"] } & product["categories"].map { _1["id"] }).length != data["categories"].length
        if diff.length > 0 || changed_category_ids
          log "Updating item #{sku}: #{diff.inspect}"
          data.merge!(id: product["id"])
        end
      end


    end

    # Save the remaining updates
    save_batch(updates: @updates, to_create: @to_create) if @updates.any? || @to_create.any?
  end

  # Given an attributes array, update the given attribute with the new value
  def update_attributes(attributes, name:, val:)
    if val.to_s == ""
      log "Missing return policy code"
      return
    end

    if existing = attributes.find { _1["name"] == name }
      existing["options"] = [ val ]
    else
      attributes << { "name" => name, "options" => [ val ] }
    end
  end

  def tag_ids(row)
    return [] if row["Tags"].to_s == ""
    tags = row["Tags"].split(",").map { _1.strip }.reject { |slug| slug.nil? || slug == "" }.map(&:downcase)

    return [] if tags.empty?

    ids = tags.map do |tag|
      if id = @tag_ids[tag]
        id
      else
        log("Creating tag #{tag}")
        id = create_tag(tag)
        @tag_ids[slug] = id
        id
      end
    end.map { { "id" => _1 } }
  end

  # Return "published" if the item is in stock and is a HomeRoots product
  def status_for_row(row)
    return "draft" unless
      row["Quantity In Stock"].to_i > 0 && row["Title"].to_s.split(/\s+/).count >= 2

    "publish"
  end

  def save_batch(updates:, to_create:)
    raise("Too many to save, limit is 100") if (updates.length + to_create.length) > 100

    res = @woo.post("products/batch", { update: updates, create: to_create })
    case res.code
    when 200
      log "Saved batch!"
    else
      log "Error: #{res.code}"
    end
  end

  def lookup_product_by_sku(sku)
    @all_products.find { _1["sku"] == sku }
  end

  # Given a slug, create a new category with
  # the slug as the name, and return the ID.
  def create_category(slug, parent_slug:)
    log "Creating Category: #{slug}" + ((parent_slug) ? ", parent: #{parent_slug}, parent_id: #{@category_ids_by_slug[parent_slug]}" : "")
    data = {
      name: slug,
      slug: slug
    }
    data[:parent] = @category_ids_by_slug[parent_slug] if parent_slug

    res = @woo.post("products/categories", data).parsed_response
    res["id"]
  end

  # Given a tag, create a new tag in Woocommerce with
  # the slug as the slug, and return the ID.
  def create_tag(slug)
    log "Creating Tag <#{slug}>..."
    data = {
      name: slug,
      slug: slug
    }

    res = @woo.post("products/tags", data).parsed_response
    res["id"]
  end

  def category_ids(row)
    slugs = %w[Category Subcategory1 Subcategory2].map { row[_1] }.reject { |slug| slug.nil? || slug == "" }.map(&:downcase)
    prev_slug = nil
    all_slugs = 0.upto(slugs.length - 1).map do |n|
      hash = { slug: slugs[0..n].join("-"), parent: prev_slug }
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
    end.map { { "id" => _1 } }
  end

  # Stream log messages to the front-end
  def log(msg)
    cable_ready[ImportChannel].append(
      selector: ".updater_progress",
      html: "<div class='entry'>#{msg}</div>".html_safe
    ).broadcast_to("update_products")
  end
end

require 'uri'

module Connectors
  module Woo
    class Base
      attr_reader :client

      def initialize(url, key:, secret:)
        connection = Connection.new(url, key: key, secret: secret)
        @client = Client.new(connection: connection)
      end



      def update_product(product)
        # Eager load categories
        categories

        # Get the copy of this product from Woo
        remote_product = begin
          prod = client.get_product_by_sku(product.sku) || Connectors::Woo::Models::Product.new
          prod
        end

        remote_product.attributes = {
          sku: product.sku,
          type: "simple",
          name: product.title,
          description: product.description,
          regular_price: d2s(product.listing_price),
          manage_stock: true,
          stock_quantity: product.quantity_in_stock,
          status: product.available? ? 'publish' : 'draft',
          # product_attributes: product.product_attributes,
          # categories: product.categories,
          # tags: product.tags,
          # images: product.images.map{ { url: _1.url } }
        }

        remote_product.dimensions ||= {}
        remote_product.dimensions['width'] = d2s(product.width)
        remote_product.dimensions['height'] = d2s(product.height)
        remote_product.dimensions['length'] = d2s(product.length)

        update_categories(remote_product, product)
        update_tags(remote_product, product)
        update_images(remote_product, product)

        begin
          client.save_object('products', remote_product)
          product.update(
            last_synced_at: Time.now,
            needs_sync: false
          )
        rescue Client::UpdateError, Client::CreateError => e
          puts "Unable to save product, #{e.message}"
        end
      end

      # Take the catogories off of the stored product and ensure that they are synced
      # to the server in a hierarchical way.
      def update_categories(remote_product, product)
        slugs = [product.category1, product.category2, product.category3].reject { |slug| slug.blank? }.map(&:downcase)
        prev_slug = nil
        all_slugs = 0.upto(slugs.length - 1).map do |n|
          hash = { slug: slugs[0..n].join("-"), parent_slug: prev_slug }
          prev_slug = hash[:slug]
          hash
        end.uniq

        remote_product.categories = all_slugs.map do |hash, i|
          slug = hash[:slug]
          cat = categories[slug] || create_category(slug, parent_slug: hash[:parent])
          {
            "id" => cat.id,
            "name" => cat.name,
            "slug" => cat.slug
          }
        end
      end



      def update_tags(remote_product, product)
        return [] if product.tags.empty?

        tags = product.tag_list.map(&:downcase)

        remote_product.tags = tags.map do |slug|
          if existing = cached_tags[tag]
            existing
          else
            new_tag = create_tag(tag)
            @tag_ids[tag] = new_tag
            new_tag
          end
        end
      end

      def update_images(remote_product, product)
        # Transform remote and local lists to be a hash with a key that
        # has the last part of the image path and a value that has the rest of the object
        #
        remote = (remote_product.images || []).each_with_object({}) do |img, obj|
          filename = URI(img['src']).path.split('/').last
          obj[filename] = img
        end
        local = product.images.each_with_object({}) do |img, obj|
          filename = URI(img.url).path.split('/').last
          obj[filename] = img
        end

        to_delete = remote.keys - local.keys
        to_add = local.keys - remote.keys

        remote_product.images = (remote_product.images || []) - remote.slice(*to_delete).values
        to_add.each do |key|
          remote_product.images << { 'src' => local[key].url }
        end
      end

      def create_category(slug, parent_slug: nil)
        parent_id = parent_slug ? categories[parent_slug].id : 0
        new_category = client.create_category(slug, parent_id: parent_id)
        categories[slug] = new_category
        new_category
      end

      def create_tag(slug)
        new_tag = client.create_tag(slug)
        cached_tags[slug] = new_tag
        new_tag
      end

      private

      def categories
        @categories_by_slug ||= Rails.cache.fetch("tenant-3-all-categories", expires_in: 1.day) do
          client.get_all_categories.each_with_object({}) do |cat, hash|
            hash[cat.slug] = cat
          end
        end
      end

      def cached_tags
        @tags_by_slug ||= Rails.cache.fetch("tenant-2-all-tags", expires_in: 1.day) do
          client.get_all_tags.each_with_object({}) do |tag, hash|
            hash[tag.slug] = tag
          end
        end
      end

      # Convert a decimal to a string with two decimal places
      # This is used to convert prices to strings for API calls
      def d2s(value)
        return value.to_i.to_s if value.to_i == value

        "%.2f" % BigDecimal(value).truncate(2)
      rescue TypeError
        ''
      end


    end
  end
end

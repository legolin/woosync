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
          client.get_product_by_sku(product.sku) || Connectors::Woo::Models::Product.new
        end

        remote_product.attributes = {
          sku: product.sku,
          type: "simple",
          name: product.title,
          description: product.description,
          regular_price: d2s(product.listing_price),
          manage_stock: true,
          stock_quantity: product.quantity_in_stock,
          # product_attributes: product.product_attributes,
          # categories: product.categories,
          dimensions: {
            width: d2s(product.width),
            height: d2s(product.height),
            length: d2s(product.length)
          },
          # tags: product.tags,
          # images: product.images.map{ { url: _1.url } }
        }

        update_categories(remote_product, product)
        # update_tags(remote_product, product.tags)
        # update_images(remote_product, product.images)

        puts remote_product.attributes_for_post.inspect
      end

      # Take the catogories off of the stored product and ensure that they are synced
      # to the server in a hierarchical way.
      def update_categories(prod, product)
        slugs = [product.category1, product.category2, product.category3].reject { |slug| slug.blank? }.map(&:downcase)
        prev_slug = nil
        all_slugs = 0.upto(slugs.length - 1).map do |n|
          hash = { slug: slugs[0..n].join("-"), parent_slug: prev_slug }
          prev_slug = hash[:slug]
          hash
        end.uniq

        prod.categories = all_slugs.map do |hash, i|
          slug = hash[:slug]
          categories[slug] || create_category(slug, parent_slug: hash[:parent])
        end
      end



      def update_tags(prod, categories)
      end

      def update_images(prod, categories)

      end

      def create_category(slug, parent_slug: nil)
        parent_id = parent_slug ? categories[parent_slug].id : 0
        new_category = client.create_category(slug, parent_id: parent_id)
        categories[slug] = new_category
        new_category
      end

      private

      def categories
        @categories_by_slug ||= Rails.cache.fetch("tenant-3-all-categories", expires_in: 1.day) do
          client.get_all_categories.each_with_object({}) do |cat, hash|
            hash[cat.slug] = cat
          end
        end
      end

      def tags
        @tags_by_slug ||= Rails.cache.fetch("tenant-2-all-tags", expires_in: 1.day) do
          client.get_all_tags.each_with_object({}) do |tag, hash|
            hash[tag.slug] = tag
          end
        end
      end

      # Convert a decimal to a string with two decimal places
      # This is used to convert prices to strings for API calls
      def d2s(value)
        "%.2f" % BigDecimal(value).truncate(2)
      rescue TypeError
        ''
      end


    end
  end
end

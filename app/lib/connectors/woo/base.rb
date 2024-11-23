module Connectors
  module Woo
    class Base
      def initialize(url, key:, secret:)
        @connection = Connection.new(url, key: key, secret: secret)
        Models::Base.connection = @connection
        preload_tags_and_categories
      end

      def update_product(product)
      end

      private

      def preload_tags_and_categories
        @category_ids_by_slug = Models::Category
          .all
          .each_with_object({}) do |cat, hash|
            hash[cat["slug"]] = cat["id"]
          end

        @tag_ids_by_slug = Models::Tag
          .all
          .each_with_object({}) do |tag, hash|
            hash[tag["slug"]] = tag["id"]
          end
      end
    end
  end
end

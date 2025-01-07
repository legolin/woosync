module Connectors
  module Woo
    # The Client class provides logic for making RESTful API calls to the
    # WooCommerce API
    #
    class Client
      class UpdateError < StandardError; end
      class CreateError < StandardError; end
      class GetError < StandardError; end
      class NotFoundError < StandardError; end

      DEFAULT_PAGINATION_PARAMS = {page: 1, per_page: 100}.freeze

      attr_reader :connection

      def initialize(connection:)
        @connection = connection
      end

      def get_product_by_sku(sku)
        get("products", Models::Product, {sku: sku, context: "edit"}).first
      rescue NotFoundError
        nil
      end

      def get_all_categories
        get_all('products/categories', Models::Category)
      end

      def get_all_tags
        get_all('products/tags', Models::Tag)
      end

      def create_category(slug, parent_id)
        category = Models::Category.new(
          name: slug,
          slug: slug
        )
        category.parent = parent_id if parent_id

        save_object("products/categories", category)
      end

      def create_tag(slug)
        tag = Models::Tag.new(
          name: slug,
          slug: slug
        )

        save_object("products/tags", tag)
      end

      def get(path, klass, params = {}, options = {})
        res, err = connection.get(path, DEFAULT_PAGINATION_PARAMS.merge(params.symbolize_keys))

        raise NotFoundError, "Unable to find requested resource" if err && err.code == 404
        raise GetError, "Unable to complete request `GET #{path}`, Error: #{err.message}" if err

        return klass.from_api_response(res) unless res.is_a?(Array)

        res.map { klass.from_api_response(_1) }
      end

      def get_all(path, klass, params = {}, options = {})
        page = 1; page_size = 100
        combined = []
        1.upto(100) do |page|
          res = get(path, klass, params.merge(page: page, page_size: page_size), options)
          combined += res
          break if res.length == 0
        end
        combined
      end

      def save_object(path, object, options = {})
        if (id = object.id).present?
          res, err = connection.post("#{path}/#{id}", object.attributes_for_post)
          raise UpdateError, "Unable to update #{object.class.name} with ID #{id}, Error: #{err.message}" if err
        else
          res, err = connection.post(path, object.attributes_for_post)
          raise CreateError, "Unable to create #{object.class.name}, Error: #{err.message}" if err
        end

        object.apply_api_response(res)
        object
      end

      private


    end
  end
end

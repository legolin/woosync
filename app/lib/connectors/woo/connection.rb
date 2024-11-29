module Connectors
  module Woo
    # This base class provides functionality for calling WooCommerce API endpoints.
    class Connection
      ApiError = Struct.new(:code, :message)
      def initialize(url, key:, secret:)
        @woo = WooCommerce::API.new(
          url,
          key,
          secret,
          {
            wp_api: true,
            version: "wc/v3"
          }
        )
      end

      def get(url, options = {})
        process_response(@woo.get(url, options))
      end

      def post(url, data, options = {})
        process_response(@woo.post(url, data))
      end

      private

      def process_response(res)
        case res.code
        when 200..299
          [res.parsed_response, nil]
        else
          [nil, ApiError.new(res.code, res.parsed_response['message'])]
        end
      end
    end
  end
end

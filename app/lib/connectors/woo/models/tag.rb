module Connectors
  module Woo
    module Models
      class Tag < Base
        def self.all
          res, err = connection.get("products/tags", "page" => 1, "per_page" => 100)

          raise GetError, "Unable to get all tags, Error: #{err['message']}" if err

          res
        end

        # Given a tag, create a new tag in Woocommerce with
        # the slug as the slug, and return the ID.
        def self.create(slug)
          data = {
            name: slug,
            slug: slug
          }

          res, err = connection.post("products/tags", data)
          raise(UpdateError, "Unable to save tag #{slug}. Error: #{err['message']}")

          res["id"]
        end
      end
    end
  end
end

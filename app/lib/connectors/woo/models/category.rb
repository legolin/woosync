module Connectors
  module Woo
    module Models
      class Category < Base
        def self.all
          res, err = connection.get("products/categories", "page" => 1, "per_page" => 100)

          raise GetError, "Unable to get all categories, Error: #{err['message']}" if err

          res
        end

        # Given a slug, create a new category with
        # the slug as the name, and return the ID.
        def self.create(slug, parent_id: nil)
          data = {
            name: slug,
            slug: slug
          }
          data[:parent] = parent_id if parent_id

          res, err = @woo.post("products/categories", data)

          raise UpdateError, "Unable to create category #{slug}#{parent_id && " with parent ID #{parent_id}.  Error: #{err['message']}"}"

          res["id"]
        end
      end
    end
  end
end

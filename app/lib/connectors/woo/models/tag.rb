module Connectors
  module Woo
    module Models
      class Tag < Base
        attribute :id, :integer
        attribute :slug, :string
        attribute :name, :string

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

        def save
          attributes_for_post = attributes.slice('name', 'slug', 'description')
          if id
            res, err = connection.post("products/tags/#{id}", self.to_h.slice(attributes_for_post))
            raise UpdateError, "Unable to update tag with ID #{id}, Error: #{err['message']}" if err
          else
            res, err = connection.post("products/tags", self.to_h.slice(attributes_for_post))
            raise CreateError, "Unable to create tag, Error: #{err['message']}" if err
          end

          # After saving the response attributes, mark everything as clean
          apply_api_response(res)
        end
      end
    end
  end
end

module Connectors
  module Woo
    module Models
      class Category < Base

        attribute :id, :integer
        attribute :slug, :string
        attribute :name, :string
        attribute :parent, :integer

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

        def save
          attributes_for_post = attributes.slice('name', 'description', 'parent')
          if id
            res, err = connection.post("products/categories/#{id}", self.to_h.slice(attributes_for_post))
            raise UpdateError, "Unable to update category with ID #{id}, Error: #{err['message']}" if err
          else
            res, err = connection.post("products/categories", self.to_h.slice(attributes_for_post))
            raise CreateError, "Unable to create category, Error: #{err['message']}" if err
          end

          # After saving the response attributes, mark everything as clean
          apply_api_response(res)
        end

        def attributes_for_post
          attributes.slice('name', 'description', 'parent')
        end
      end
    end
  end
end

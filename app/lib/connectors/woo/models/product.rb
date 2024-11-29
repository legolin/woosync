module Connectors
  module Woo
    module Models
      class Product < Base

        attribute :id, :integer
        attribute :type, :string
        attribute :sku, :string
        attribute :status, :string
        attribute :name, :string
        attribute :description, :string

        attribute :regular_price, :decimal

        attribute :manage_stock, :boolean
        attribute :stock_quantity, :integer

        attribute :product_attributes
        attribute :categories
        attribute :dimensions
        attribute :tags
        attribute :images

        def attributes_for_post(full = false)
          full_raw_hash = self.attributes.slice(*self.attribute_names).transform_keys('product_attributes' => 'attributes')
          filtered_raw_hash = if full
            full_raw_hash
          else
            full_raw_hash.slice(changes.keys)
          end

          filtered_raw_hash.tap do |hash|
            hash['categories'] = hash['categories'].map { |category| { id: category.id } }
            hash['tags'] = (hash['tags'] || []).map { |tag| { id: tag.id } }
          end
        end

        # Overwrite api response transformation to rewrite attributes to product attributes
        #
        def apply_api_response(res)
          self.attributes = res.transform_keys('attributes' => 'product_attributes').slice(*self.attribute_names)
        end
      end
    end
  end
end

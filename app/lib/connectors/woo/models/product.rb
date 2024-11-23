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

        attribute :attributes
        attribute :categories
        attribute :dimensions
        attribute :tags
        attribute :images

        def self.get_product_by_sku(sku)
          res, err = connection.get("products", sku: sku, context: "edit")

          raise GetError, "Unable to fetch product with SKU #{sku}, Error: #{err['message']}" if err
          raise NotFoundError, "Product with SKU #{sku} not found" if res.empty?

          new(**res.first.slice(*self.attribute_names))
        end
      end
    end
  end
end

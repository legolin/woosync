class Mapping < ApplicationRecord
  belongs_to :feed

  validates :input_field, presence: true

  OUTPUT_FIELDS = {
    'Ignore this column' => nil,
    'Supplier' => :supplier_code,
    'SKU' => :sku,
    'Title' => :title,
    'Description' => :description,
    'Width' => :width,
    'Height' => :height,
    'Length' => :length,
    'Weight' => :weight,
    'Price' => :price,
    'MSRP' => :msrp,
    'Shipping Cost' => :shipping_cost,
    'Category 1' => :category1,
    'Category 2' => :category2,
    'Category 3' => :category3,
    'Tags' => :tags,
    'Images' => :images,
    'Return Policy Code' => :return_policy_code,
    'Quantity in Stock' => :quantity_in_stock
  }

  OPTIONS = {
    :attribute => {
      attribute_name: :string
    }
  }
end

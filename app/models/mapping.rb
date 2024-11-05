class Mapping < ApplicationRecord
  belongs_to :feed

  OUTPUT_FIELDS = {
    'Ignore this column' => nil,
    'Supplier' => :supplier_code,
    'SKU' => :sku,
    'Title' => :title,
    'Description' => :description,
    'Width' => :width,
    'Height' => :height,
    'Depth' => :depth,
    'Weight' => :weight,
    'Price' => :price,
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

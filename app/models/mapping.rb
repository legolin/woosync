class Mapping < ApplicationRecord
  belongs_to :feed

  OUTPUT_FIELDS = {
    :supplier_code => 'Supplier',
    :sku => 'SKU',
    :title => 'Title',
    :description => 'Description',
    :width => 'Width',
    :height => 'Height',
    :length => 'Length',
    :weight => 'Weight',
    :price => 'Price',
    :msrp => 'MSRP',
    :shipping_cost => 'Shipping Cost',
    :category1 => 'Category 1',
    :category2 => 'Category 2',
    :category3 => 'Category 3',
    :tags => 'Tags',
    :images => 'Images',
    :return_policy_code => 'Return Policy Code',
    :quantity_in_stock => 'Quantity in Stock'
  }

  OPTIONS = {
    :attribute => {
      attribute_name: :string
    }
  }
end

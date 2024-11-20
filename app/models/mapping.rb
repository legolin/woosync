class Mapping < ApplicationRecord
  belongs_to :feed

  OUTPUT_FIELDS = {
    :supplier_code => {
      label: 'Supplier'
    },
    :sku => {
      label: 'SKU'
    },
    :quantity_in_stock => { label: 'Quantity in Stock' },
    :price => { label: 'Price' },
    :msrp => { label: 'MSRP' },
    :shipping_cost => { label: 'Shipping Cost' },
    :title => {
      label: 'Title'
    },
    :description => { label: 'Description', import_methods: [:simple, :multi_source_text] },
    :width => { label: 'Width' },
    :height => { label: 'Height' },
    :length => { label: 'Length' },
    :weight => { label: 'Weight' },

    :category1 => { label: 'Category 1' },
    :category2 => { label: 'Category 2' },
    :category3 => { label: 'Category 3' },
    :tags => { label: 'Tags', type: 'array', import_methods: [:split_string, :multi_source_array] },
    :images => { label: 'Images', import_methods: [:split_string, :multi_source_array] },
    :return_policy_code => { label: 'Return Policy Code' },

  }

  OPTIONS = {
    :attribute => {
      attribute_name: :string
    }
  }
end

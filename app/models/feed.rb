class Feed < ApplicationRecord
  has_many :mappings, dependent: :destroy
  belongs_to :supplier

  accepts_nested_attributes_for :mappings, allow_destroy: true, reject_if: :all_blank

  validates :supplier, :feed_type, presence: true
  validates :feed_type, inclusion: { in: %w[update delete] }

  def import_products(file)
    changes = []
    csv = CSV.parse(file.read.force_encoding("UTF-8"), headers: true)
    csv.each do |row|
      sku = row['sku'] || row['SKU']
      product = Product.where(sku: sku, supplier_id: supplier_id).first_or_initialize
      mappings.each do |mapping|

        next if mapping.output_field.blank?

        case mapping.output_field
        when 'sku', 'supplier_code', 'return_policy_code'
          # Noop
        when 'images'
        else
          value = row[mapping.input_field]
          product[mapping.output_field] = value
        end
      end
      changes << product.changes
      product.save
    end
    changes
  end
end

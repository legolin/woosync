class Feed < ApplicationRecord
  has_many :mappings, dependent: :destroy
  belongs_to :supplier, optional: true

  accepts_nested_attributes_for :mappings, allow_destroy: true, reject_if: :all_blank

  validates :feed_type, inclusion: { in: %w[update delete] }

  # Display the title if provided, or generate a title from the supplier and action.
  def display_name
    return title if title.present?
    "#{supplier&.name || "Generic"} - #{feed_type.capitalize}"
  end

  def import_products(file)
    changes = []
    suppliers = Supplier.all.each_with_object({}) { |supplier, hash| hash[supplier.slug.downcase] = supplier }
    csv = CSV.parse(file.read.force_encoding("UTF-8"), headers: true)
    csv.each do |row|
      sku = row['sku'] || row['SKU']
      product = Product.where(sku: sku).first_or_initialize
      mappings.each do |mapping|
        # Skip this mapping if no output field is defined
        next if mapping.output_field.blank?

        # Get the value from the CSV
        value = row[mapping.input_field]

        # Some output fields have special behaviors.
        case mapping.output_field
        when 'supplier_code'
          # next if self.supplier_id
          product.supplier_id = suppliers[value.downcase].id
        when 'sku', 'return_policy_code'
          # Noop
        when 'images'
          product.image_list = value.to_s.split(mapping.array_separator).map(&:strip)
        when 'tags'
          product.tag_list = value
        else
          product[mapping.output_field] = value
        end
      end
      changes << product.changes
      product.save!
    end
    changes
  end

  def create_mappings_from_headers
    headers = parsed_data_rows.first.keys.map(&:to_s).map(&:downcase)
    output_fields = if supplier
      Mapping::OUTPUT_FIELDS.except(:supplier_code)
    else
      Mapping::OUTPUT_FIELDS
    end
    mappings.destroy_all
    output_fields.each do |key, opts|
      best_guess = headers.find{ _1.parameterize == key.to_s }
      mappings.create(input_field: nil, output_field: key, enabled: false)
    end
  end
end

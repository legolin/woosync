class CreateMappings < ActiveRecord::Migration[8.0]
  def change
    create_table :mappings do |t|
      t.references :feed

      # A field name in the CSV
      t.string :input_field

      # A field in the `inventories` table
      t.string :output_field

      # Optional array separator
      t.string :array_separator, default: ','

      t.timestamps
    end
  end
end

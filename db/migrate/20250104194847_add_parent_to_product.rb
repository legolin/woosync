class AddParentToProduct < ActiveRecord::Migration[8.0]
  def change
    create_table :variations do |t|
      t.references :product
      t.string :regular_price, default: '0.00'
      t.timestamps
    end

    create_table :attributes do |t|
      t.string :slug, null: false
      t.string :name, null: false
    end

    create_table :product_attributes do |t|
      t.references :product
      t.references :attribute
      t.json :term_slugs
      t.timestamps
    end

    create_table :attribute_terms do |t|
      t.references :attribute
      t.string :slug, null: false
      t.string :name, null: false
      t.string :display_name, default: ''
    end

    create_table :variation_attributes do |t|
      t.references :variation
      t.references :attribute
      t.references :attribute_term
    end

    # Prefix can be auto-prepended to SKUs to ensure that they are unique
    # if the supplier can't guarantee unique SKUs
    add_column :suppliers, :sku_prefix, :string, default: ''

    # Products have categories.  For the moment, we will store these un-parsed.
    add_column :products, :categories, :text

    # Variations have images, so we will add a foreign key to images
    add_column :images, :variation_id, :integer
    add_index :images, :variation_id
  end
end

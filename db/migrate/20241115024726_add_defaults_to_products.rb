class AddDefaultsToProducts < ActiveRecord::Migration[8.0]
  def change
    change_column :products, :quantity_in_stock, :integer, default: 0, null: false
    change_column :products, :sku, :string, null: false
    add_index :products, :sku, unique: true
  end
end

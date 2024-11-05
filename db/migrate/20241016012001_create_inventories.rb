class CreateInventories < ActiveRecord::Migration[8.0]
  def change
    create_table :inventories do |t|
      t.string :sku
      t.string :state

      t.string :title
      t.string :description

      t.string :custom_title
      t.string :custom_description

      t.string :width
      t.string :height
      t.string :depth
      t.string :weight

      t.string :price

      t.json :categories
      t.json :tags
      t.json :images

      t.json :attributes

      t.integer :quantity_in_stock

      t.datetime :last_synced_at

      t.timestamps

      t.index :sku, unique: true
    end
  end
end

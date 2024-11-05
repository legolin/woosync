class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :suppliers do |t|
      t.string :name
    end

    create_table :return_policy_codes do |t|
      t.string :code
      t.string :name
      t.string :description
      t.index :code, unique: true
    end

    create_table :products do |t|
      t.references :supplier, null: false, foreign_key: true
      t.string :sku
      t.string :title
      t.string :custom_title
      t.text :description
      t.text :custom_description
      t.decimal :price, precision: 10, scale: 2
      t.integer :quantity_in_stock
      t.decimal :shipping_cost, precision: 10, scale: 2
      t.decimal :height, precision: 10, scale: 2
      t.decimal :width, precision: 10, scale: 2
      t.decimal :length, precision: 10, scale: 2
      t.string :size_unit, default: 'in'
      t.decimal :weight, precision: 10, scale: 2
      t.string :weight_unit, default: 'lb'
      t.string :category1
      t.string :category2
      t.string :category3
      t.references :return_policy_code
      t.timestamps
    end

    create_table :images do |t|
      t.references :product, null: false, foreign_key: true
      t.string :url
    end
  end
end

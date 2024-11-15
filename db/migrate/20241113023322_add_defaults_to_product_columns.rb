class AddDefaultsToProductColumns < ActiveRecord::Migration[8.0]
  def change
    change_column :products, :title, :string, default: ""
    change_column :products, :custom_title, :string, default: ""
    change_column :products, :description, :string, default: ""
    change_column :products, :custom_description, :string, default: ""
  end
end

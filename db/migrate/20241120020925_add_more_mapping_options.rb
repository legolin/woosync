class AddMoreMappingOptions < ActiveRecord::Migration[8.0]
  def change
    add_column :mappings, :import_method, :string, default: 'simple'
    change_column :mappings, :import_field, :text
    remove_column :mappings, :simple
  end
end

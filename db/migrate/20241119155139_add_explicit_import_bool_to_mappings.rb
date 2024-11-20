class AddExplicitImportBoolToMappings < ActiveRecord::Migration[8.0]
  def change
    add_column :mappings, :enabled, :boolean, default: false
    add_column :mappings, :simple, :boolean, default: true
  end
end

class AddSettingsToSuppliers < ActiveRecord::Migration[8.0]
  def change
    add_column :suppliers, :slug, :string, default: '', null: false
    add_column :suppliers, :default_values, :jsonb, default: {}, null: false
    add_column :suppliers, :status_rules, :jsonb, default: {}, null: false
    add_column :products, :state, :string, default: 'active'
    add_column :products, :needs_sync, :boolean, default: 'true'
    add_column :products, :last_synced_at, :datetime
  end
end

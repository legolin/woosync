class AddSettingsToFeeds < ActiveRecord::Migration[8.0]
  def change
    add_column :feeds, :on_update_update_existing_entries, :boolean, default: true
    add_column :feeds, :on_update_undelete_deleted_entries, :boolean, default: false
  end
end

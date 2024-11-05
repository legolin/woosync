class CreateImports < ActiveRecord::Migration[8.0]
  def change
    create_table :imports do |t|
      t.string :filename
      t.string :status, default: 'pending'
      t.text :error_message
      t.json :log_entries
      t.timestamps
    end
  end
end

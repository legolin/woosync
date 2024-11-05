class AddSampleDataToMappings < ActiveRecord::Migration[8.0]
  def change
    add_column :mappings, :sample_data, :text, default: ''
  end
end

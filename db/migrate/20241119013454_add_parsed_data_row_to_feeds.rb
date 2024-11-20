class AddParsedDataRowToFeeds < ActiveRecord::Migration[8.0]
  def change
    add_column :feeds, :parsed_data_rows, :json
  end
end

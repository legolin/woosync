class AddSupplierToFeeds < ActiveRecord::Migration[8.0]
  def change
    add_reference :feeds, :supplier
  end
end

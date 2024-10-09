class UpdateProductsJob < ApplicationJob
  queue_as :default

  def perform(csv_path)
    ProductUpdater.new.perform(csv_path)

    # Clean up
    File.rm(persisted_file_path)
  end
end

require "csv"

class ProductsController < ApplicationController
  def batch_edit
  end

  def batch_update
    FileUtils.mkdir_p(Rails.root.join("tmp", "uploads"))
    persisted_file_path = Rails.root.join("tmp", "uploads", SecureRandom.uuid)
    File.write(persisted_file_path, params[:product_list].read.force_encoding("UTF-8"))
    UpdateProductsJob.perform_later String(persisted_file_path)
    redirect_to batch_update_progress_products_path
  end

  def batch_update_progress
  end

  def batch_delete
  end

  def do_batch_delete
  end
end

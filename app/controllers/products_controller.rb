require "csv"

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :set_nav_slug

  layout :resolve_layout

  def index
    product_scope = Product.all.includes(:supplier)
    product_scope = product_scope.where(supplier_id: params[:supplier_id]) if params[:supplier_id].present?
    product_scope = product_scope.where("sku = :filter OR title like :infilter or description like :infilter or custom_title like :infilter or custom_description like :infilter", filter: params[:filter], infilter: "%#{params[:filter]}%") if params[:filter].present?
    @pagy, @products = pagy(product_scope)
  end

  def show
    respond_to do |format|
      format.html
      format.turbo_stream { render :show }
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.turbo_stream { render :edit }
    end
  end

  def update
    @product.update(product_params)
    respond_to do |format|
      format.html { redirect_to product_path(@product) }
      format.turbo_stream { render :update }
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

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

  private

  def product_params
    params.require(:product).permit(:custom_title, :custom_description, :price, :shipping_cost, :state_event)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def set_nav_slug
    @nav_slug = :products
  end

  def resolve_layout
    return 'sidebar' if turbo_frame_request?

    'application'
  end
end

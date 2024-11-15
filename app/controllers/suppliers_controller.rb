class SuppliersController < ApplicationController
  before_action :set_nav_slug

  def create
    @supplier = Supplier.new(supplier_params)
    return redirect_to(suppliers_path) if @supplier.save

    render 'new'
  end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def update
    @supplier = Supplier.find(params[:id])
    return redirect_to(suppliers_path) if @supplier.update(supplier_params)

    render 'edit'
  end

  def new
    @supplier = Supplier.new
  end

  def index
    @suppliers = Supplier.all.includes(:feeds)
  end

  private

  def supplier_params
    params.require(:supplier).permit(:name, :slug, :price_calculation_rule)
  end

  def set_nav_slug
    @nav_slug = :suppliers
  end
end

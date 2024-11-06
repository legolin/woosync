class SuppliersController < ApplicationController
  def create
    @supplier = Supplier.new(supplier_params)
    return redirect_to(suppliers_path) if @supplier.save

    render 'new'
  end

  def new
    @supplier = Supplier.new
  end

  def index
    @suppliers = Supplier.all.includes(:feeds)
  end

  def supplier_params
    params.require(:supplier).permit(:name)
  end
end

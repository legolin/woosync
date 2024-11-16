module ProductsHelper
  # Render collection options for a product filter dropdown,
  # with one entry for each supplier and an entry for "All suppliers"
  def suppliers_for_products_filter
    [['All Suppliers', nil]] + Supplier.all.map{ [_1.name, _1.id] }
  end
end

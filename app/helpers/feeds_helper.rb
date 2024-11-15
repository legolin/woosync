module FeedsHelper
  # Return options for a dropdown.  The default option
  # is "Generic", which means that the data source must include the supplier
  # name.
  def suppliers_for_feed
    options = [['Generic - Specified by "Supplier" column in CSV)', '']]
    Supplier.all.each do |supplier|
      options << [supplier.name, supplier.id]
    end
    options
  end
end

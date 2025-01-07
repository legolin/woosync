module SupplierHelpers
  def get_supplier(name = "Test Supplier")
    @suppliers = {}
    @last_supplier = @suppliers[name] ||= begin
      Supplier.find_by_name(name) || FactoryBot.create(:supplier, name: name)
    end
  end
end

World(SupplierHelpers)

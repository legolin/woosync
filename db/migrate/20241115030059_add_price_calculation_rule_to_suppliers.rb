class AddPriceCalculationRuleToSuppliers < ActiveRecord::Migration[8.0]
  def change
    add_column :suppliers, :price_calculation_rule, :text
  end
end

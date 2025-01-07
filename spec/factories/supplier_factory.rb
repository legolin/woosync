FactoryBot.define do
  factory :supplier do
    name { "Test Supplier" }
    slug { name.parameterize }
    sku_prefix { "TS" }
  end
end

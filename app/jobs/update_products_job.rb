class UpdateProductsJob < ApplicationJob
  queue_as :default

  def perform(product_id)
    product = Product.find(product_id)

    connector = Connectors::Woo::Base.new(
      "https://salomefurnishings.com",
      key: Rails.application.credentials.dig(:woo_api, :key),
      secret: Rails.application.credentials.dig(:woo_api, :secret)
    )

    result = connector.update_product(product)
    puts result.inspect
  end
end

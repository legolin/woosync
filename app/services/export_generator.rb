class ExportGenerator
  def generate(product_scope)
    csv_string = CSV.generate do |csv|
      csv << [
        "supplier",
        "sku",
        "status",
        "title",
        "description",
        "custom_title",
        "custom_description",
        "price",
        "generated_price",
        "msrp",
        "shipping_cost",
        "tags",
        "width",
        "height",
        "length",
        "weight"
      ]
      product_scope.find_in_batches do |batch|
        batch.each do |product|
          csv << [
            product.supplier.slug,
            product.sku,
            product.state,
            product.title,
            product.description,
            product.custom_title,
            product.custom_description,
            product.price,
            product.generated_price,
            product.msrp,
            product.shipping_cost,
            product.tag_list,
            product.width,
            product.height,
            product.length,
            product.weight
          ]
        end
      end
    end

    csv_string
  end
end

Given 'a simple {word} feed configured with mappings:' do |feed_type, table|
  @feed = FactoryBot.create(:feed, feed_type: feed_type, supplier: get_supplier)
  table.hashes.each do |row|
    @feed.mappings << Mapping.create(row)
  end
end

When 'I import {fixture_file}' do |filename|
  file = fixture_file(filename)
  @feed.import_products(file)
end

Then 'I have products:' do |table|
  table.hashes.each do |row|
    product = Product.find_by(sku: row['sku'])
    row.each do |raw_key, value|
      case raw_key
      when /_contains$/
        key = raw_key.gsub('_contains', '')
        expect(product.send(key.to_sym)).to include(value)
      else
        expect(product.send(raw_key.to_sym)).to eq(value)
      end
    end
  end
end

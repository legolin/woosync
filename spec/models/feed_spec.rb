require 'rails_helper'

describe Feed, type: :model do
  subject(:instance) { FactoryBot.create(:feed) }

  describe '#import' do

    # Run the test
    def run_import(feed_path)
      instance.import_products(fixture_file(feed_path))
    end

    given 'a list of simple products' do
      let(:feed_path) { 'product_feeds/honey-run-simple.csv'}

      it 'succeeds' do
        run_import(feed_path)
      end
    end

    given 'a list of products with variants' do
      let(:feed_path) { 'product_feeds/honey-run-simple.csv'}
    end
  end
end

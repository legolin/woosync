class ImportsController < ApplicationController

  # Render a form that accepts a products CSV
  # and a feed ID.
  #
  # The products CSV will be imported into the products table
  # according to the feed mappings.
  #
  def new
    @feeds = Feed.where(feed_type: params[:feed_type]).includes(:supplier).order(:'suppliers.name')
  end

  def create
    @feed = Feed.find(params.dig(:import, :feed_id))
    @changes = @feed.import_products(params.dig(:import, :products).tempfile)
    redirect_to products_path
  end

  private

  def load_feed
    @feed = Feed.find(params[:feed_id])
  end
end

class ImportsController < ApplicationController
  before_action :load_feed, only: %i[new create]

  # Render a form that accepts a products CSV
  # and a feed ID.
  #
  # The products CSV will be imported into the products table
  # according to the feed mappings.
  #
  def new
  end

  def create
    @changes = @feed.import_products(params[:products].tempfile)
  end

  private

  def load_feed
    @feed = Feed.find(params[:feed_id])
  end
end

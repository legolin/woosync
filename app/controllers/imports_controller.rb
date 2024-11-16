class ImportsController < ApplicationController
  before_action :set_nav_slug

  # Render a form that accepts a products CSV
  # and a feed ID.
  #
  # The products CSV will be imported into the products table
  # according to the feed mappings.
  #
  def new
    @update_feeds = Feed.where(feed_type: 'update').includes(:supplier).order(:'suppliers.name')
    @delete_feeds = Feed.where(feed_type: 'delete').includes(:supplier).order(:'suppliers.name')
  end

  # Render a CSV upload area that the user can use to kick off a product import.
  #
  def choose_upload
    @feed = Feed.find(params[:feed_id])
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

  def set_nav_slug
    @nav_slug = :imports
  end
end

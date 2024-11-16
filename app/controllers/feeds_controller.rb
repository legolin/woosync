class FeedsController < ApplicationController
  before_action :load_feed, only: %i[show edit destroy update]
  before_action :set_nav_slug

  def new
    @supplier = Supplier.find_by(id: params[:supplier_id])
  end

  def create
    @feed = Feed.create!(feed_params)

    redirect_to batch_edit_feed_mappings_path(@feed)
  end

  def show
  end

  def edit
  end

  def index
    @feeds = Feed.all
  end

  def update
    if @feed.update(feed_params)
      redirect_to feeds_path
    else
      render :edit
    end
  end

  def destroy
    @feed.destroy

    redirect_to feeds_path
  end

  private

  def load_feed
    @feed = Feed.includes(:supplier).find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:title, :description, :url, :feed_type, :supplier_id,
      mappings_attributes: [:id, :input_field, :output_field, :_destroy])
  end

  def set_nav_slug
    @nav_slug = :feeds
  end
end

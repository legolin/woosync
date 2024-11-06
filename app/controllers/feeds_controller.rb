class FeedsController < ApplicationController
  before_action :load_feed, only: %i[show edit destroy update]

  def new
    @supplier = Supplier.find(params[:supplier_id])
    @feed = Feed.where(supplier: @supplier, feed_type: params[:feed_type]).first_or_create
  end

  def create
    @feed = Feed.create!(supplier_id: params[:supplier_id], feed_type: params[:feed_type])

    redirect_to edit_feed_mappings_path(@feed)
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
      redirect_to @feed, notice: 'Feed was successfully updated.'
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
    params.require(:feed).permit(:title, :description, :url, :feed_type,
      mappings_attributes: [:id, :input_field, :output_field, :_destroy])
  end
end

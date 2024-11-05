class FeedsController < ApplicationController
  before_action :load_feed, only: %i[show edit destroy update]

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.create(feed_params)
    return render(:new) unless @feed.persisted?

    redirect_to feed_path(@feed)
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
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:title, :description, :url, :feed_type,
      mappings_attributes: [:id, :input_field, :output_field, :_destroy])
  end
end

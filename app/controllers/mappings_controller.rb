class MappingsController < ApplicationController
  before_action :load_feed

  # When the user uploads a CSV, we can extract the headers from the first row
  # and use them to build out a list of mappings.  Each mapping also gets the value
  # from that row for preview purposes.
  def from_file
    unless params[:file].present?
      redirect_to feed_path(@feed), alert: 'Please select a file'
    end

    parsed_csv = CSV.parse(params[:file].read, headers: true)

    row = parsed_csv.first
    row.each do |key, value|
      @feed.mappings.build(input_field: key, output_field: nil, sample_data: value)
    end

    render :batch_edit
  end

  def batch_edit
    render :upload_file if @feed.mappings.empty?
  end

  def batch_update
  end

  private

  def load_feed
    @feed = Feed.find(params[:feed_id])
  end
end

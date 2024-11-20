class MappingsController < ApplicationController
  before_action :load_feed

  # When the user uploads a CSV, we can extract the headers from the first row
  # and use them to build out a list of mappings.  Each mapping also gets the value
  # from that row for preview purposes.
  def from_file
    unless params.dig(:feed, :file).present?
      redirect_to feed_path(@feed), alert: 'Please select a file'
    end

    parsed_csv = CSV.parse(params.dig(:feed, :file).read.force_encoding('UTF-8'), headers: true)

    @feed.update(parsed_data_rows: parsed_csv[0..100].sample(5).map(&:to_h))

    @feed.create_mappings_from_headers

    render :batch_edit
  end

  def batch_edit
    @feed.create_mappings_from_headers unless @feed.mappings.any?

    render :upload_file if @feed.parsed_data_rows.nil?
  end

  def batch_update
  end

  private

  def load_feed
    @feed = Feed.find(params[:feed_id])
  end
end

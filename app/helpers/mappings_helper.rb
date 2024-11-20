module MappingsHelper
  # Calculate the best match for a mapping object
  def best_match(mapping_object)
    headers = @feed.parsed_data_rows.first.keys
    match = headers.find { _1.parameterize == mapping_object.output_field.to_s }
    return nil unless match

    match
  end
end

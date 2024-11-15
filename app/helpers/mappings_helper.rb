module MappingsHelper
  # Calculate the best match for a mapping object
  def best_match(mapping_object)
    keys = Mapping::OUTPUT_FIELDS.keys
    match = keys.find { _1.parameterize == mapping_object.input_field.parameterize }
    return nil unless match

    Mapping::OUTPUT_FIELDS[match]
  end
end

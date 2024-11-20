module MappingsHelper
  # Calculate the best match for a mapping object
  def best_match(mapping_object)
    headers = @feed.parsed_data_rows.first.keys
    match = headers.find { _1.parameterize == mapping_object.output_field.to_s }
    return nil unless match

    match
  end

  def import_methods_for_mapping(mapping)
    options = Mapping::OUTPUT_FIELDS.dig(mapping.output_field.to_sym, :import_methods)
    options.map do |import_method|
      [import_method.to_s, name_for_import_method(import_method)]
    end
  end

  def name_for_import_method(method_name)
    {
      simple: 'Entry is in one column',
      multi_source_text: 'Entry is composed of text from multiple columns',
      multi_source_array: 'Entries are in separate columns',
      split_string: 'Entries are in one column, separated by comma or other character'
    }[method_name.to_sym]
  end
end

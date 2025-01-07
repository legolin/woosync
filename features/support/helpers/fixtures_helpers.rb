module FixturesHelpers
  def fixture_file(filename)
    File.open(Rails.root.join('features', 'fixtures', 'files', filename), 'r')
  end

  def last_feed
    @last_feed
  end
end

ParameterType(
  name: 'fixture_file',
  regexp: /"([^"]+\.(csv|json))"/,
  type: String,
  transformer: ->(s) { fixture_file(s) },
  use_for_snippets: false
)

World(FixturesHelpers)

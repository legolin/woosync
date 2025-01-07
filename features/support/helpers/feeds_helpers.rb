module FeedsHelpers
  def lookup_feed(feed_name)
    @feeds ||= {}
    @last_feed = feed_name
    @users[feed_name] ||= FactoryBot.generate(:feed)
  end

  def last_feed
    @last_feed
  end
end

ParameterType(
  name: 'feed',
  regexp: /[\w']+/,
  type: String,
  transformer: ->(s) { s.sub(/'s$/, '') },
  use_for_snippets: false
)

World(FeedsHelpers)

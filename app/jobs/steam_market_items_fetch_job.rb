class SteamMarketItemsFetchJob
  include Sidekiq::Worker
  sidekiq_options queue: :fetch_items

  def perform(_app_id, _query_start)
    raise 'You shall not pass!' unless Rails.env.test?
  end
end

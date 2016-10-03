class SteamMarketPriceFetchJob
  include Sidekiq::Worker
  sidekiq_options queue: :fetch

  def perform(_app_id, _items)
    raise 'You shall not pass!' unless Rails.env.test?
  end
end

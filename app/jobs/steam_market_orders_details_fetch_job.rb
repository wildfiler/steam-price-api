class SteamMarketOrdersDetailsFetchJob
  include Sidekiq::Worker
  sidekiq_options queue: :fetch_orders_details

  def perform(_name_ids)
    raise 'You shall not pass!' unless Rails.env.test?
  end
end

class SteamMarketItemNameidFetchJob
  include Sidekiq::Worker
  sidekiq_options queue: :fetch_item_nameid

  def perform(_app_id, _item_name)
    raise 'You shall not pass!' unless Rails.env.test?
  end
end

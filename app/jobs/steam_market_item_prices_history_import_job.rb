class SteamMarketItemPricesHistoryImportJob
  include Sidekiq::Worker
  sidekiq_options queue: :import_item_prices_history

  def perform(app_id, item_name, stats_json)
    stats = JSON.parse(stats_json)
    importer = SteamMarket::PricesHistoryImporter.new(app_id.to_i, item_name, stats)
    importer.import
  end
end

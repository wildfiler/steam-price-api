module SteamMarket
  class PricesHistoryImporter
    attr_reader :app_id, :stats, :item

    def initialize(app_id, item_name, stats)
      @app_id, @item_name, @stats = app_id, item_name, stats
      @item = SteamMarketItem.find_by!(name: item_name)
    end

    def import
      history_price = SteamMarketItemHistoryPrice.find_by(app_id: app_id, item_id: item.id)

      if history_price
        history_price.update(
          total_amount: stats['total_amount'],
          all_time_median: stats['all_time_median'],
          last_30_amount: stats['last_30_amount'],
          last_30_median: stats['last_30_median'],
          last_7_amount: stats['last_7_amount'],
          last_7_median: stats['last_7_median'],
          last_24h_amount: stats['last_24h_amount'],
          last_24h_median: stats['last_24h_median'],
          fetched_at: Time.zone.parse(stats['fetched_at'])
        )
      else
        SteamMarketItemHistoryPrice.create!(
          app_id: app_id,
          item: item,
          total_amount: stats['total_amount'],
          all_time_median: stats['all_time_median'],
          last_30_amount: stats['last_30_amount'],
          last_30_median: stats['last_30_median'],
          last_7_amount: stats['last_7_amount'],
          last_7_median: stats['last_7_median'],
          last_24h_amount: stats['last_24h_amount'],
          last_24h_median: stats['last_24h_median'],
          fetched_at: Time.zone.parse(stats['fetched_at'])
        )
      end
    end
  end
end


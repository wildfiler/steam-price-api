class SteamMarketItemNameidsImporter
  def import
    items = SteamMarketItem.where(item_nameid: nil)

    items.each do |item|
      SteamMarketItemNameidFetchJob.perform_async(item.app_id.to_s, item.name)
    end
  end
end

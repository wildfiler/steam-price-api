class SteamMarketOrdersDetailsImporter
  def import
    items = SteamMarketItem.where.not(item_nameid: [nil, ''])

    items.each do |item|
      SteamMarketOrdersDetailsFetchJob.perform_async(item.item_nameid)
    end
  end
end

class SteamMarketItemNameidsImporter
  def initialize(items = nil)
    @items = items
  end

  def import
    items = items || SteamMarketItem.where(item_nameid: [nil, ''])

    items.each do |item|
      skip_nameid = item.item_nameid.present?
      SteamMarketItemNameidFetchJob.perform_async(item.app_id.to_s, item.name, skip_nameid)
    end
  end
end

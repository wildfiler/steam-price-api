class SteamMarketItemNameidImportJob
  include Sidekiq::Worker
  sidekiq_options queue: :import_item_nameid

  def perform(app_id, item_name, item_nameid)
    item = SteamMarketItem.where(app_id: app_id, name: item_name)
    raise "Item not found" unless item
    item.update(item_nameid: item_nameid)
  end
end

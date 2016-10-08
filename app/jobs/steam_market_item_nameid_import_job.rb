class SteamMarketItemNameidImportJob
  include Sidekiq::Worker
  sidekiq_options queue: :import_item_nameid

  def perform(app_id, item_name, item_nameid)
    SteamMarketItem.find_by(app_id: app_id, name: item_name).update(item_nameid: item_nameid)
  end
end

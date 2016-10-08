class SteamMarketItemsImportJob
  include Sidekiq::Worker
  sidekiq_options queue: :import_items

  def perform(app_id, item_names)
    item_names.each do |name|
      begin
        SteamMarketItem.find_or_create_by(app_id: app_id, name: name)
      rescue ActiveRecord::RecordNotUnique
        retry
      end
    end
  end
end

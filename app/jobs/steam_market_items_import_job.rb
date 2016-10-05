class SteamMarketItemsImportJob
  include Sidekiq::Worker
  sidekiq_options queue: :import_items

  def perform(app_id, response, response_code)
    return if response_code.to_i != 200

    response.each do |name|
      begin
        SteamMarketItem.find_or_create_by(app_id: app_id, name: name)
      rescue ActiveRecord::RecordNotUnique
        retry
      end
    end
  end
end

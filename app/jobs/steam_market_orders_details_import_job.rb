class SteamMarketOrdersDetailsImportJob
  include Sidekiq::Worker
  sidekiq_options queue: :import_orders_details

  def perform(
    item_nameid,
    steam_data,
    date_time
  )

    SteamMarketOrdersDetail.create!(
      item_nameid: item_nameid,
      highest_buy_order: steam_data['highest_buy_order'].to_f/100,
      lowest_sell_order: steam_data['lowest_sell_order'].to_f/100,
      buy_order_number: steam_data['buy_order_number'],
      sell_order_number: steam_data['sell_order_number'],
      created_at: date_time
    )
  end
end

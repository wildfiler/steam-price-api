class SteamMarketOrdersDetailsImportJob
  include Sidekiq::Worker
  sidekiq_options queue: :import_orders_details

  def perform(
    item_nameid,
    highest_buy_order,
    lowest_sell_order,
    buy_order_number,
    sell_order_number,
    date_time
  )

    SteamMarketOrdersDetail.create!(
      item_nameid: item_nameid,
      highest_buy_order: highest_buy_order.to_f/100,
      lowest_sell_order: lowest_sell_order.to_f/100,
      buy_order_number: buy_order_number,
      sell_order_number: sell_order_number,
      created_at: date_time
    )
  end
end

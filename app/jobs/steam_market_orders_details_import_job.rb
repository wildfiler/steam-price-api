class SteamMarketOrdersDetailsImportJob
  include Sidekiq::Worker
  sidekiq_options queue: :import_orders_details

  def perform(
    item_nameid,
    highest_buy_order,
    lowest_sell_order,
    buy_order_summary,
    sell_order_summary,
    date_time
  )

    SteamMarketOrdersDetail.create!(
      item_nameid: item_nameid,
      highest_buy_order: highest_buy_order.to_f/100,
      lowest_sell_order: lowest_sell_order.to_f/100,
      buy_order_summary: buy_order_summary,
      sell_order_summary: sell_order_summary,
      created_at: date_time
    )
  end
end

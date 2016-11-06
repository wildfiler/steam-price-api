class CreateSteamMarketOrdersDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :steam_market_orders_details do |t|
      t.string :item_nameid, null: false, index: true
      t.decimal :highest_buy_order, default: 0
      t.decimal :lowest_sell_order, default: 0
      t.integer :buy_order_summary, default: 0
      t.integer :sell_order_summary, default: 0

      t.timestamps null: false
    end
  end
end

class CreateSteamMarketOrdersDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :steam_market_orders_details do |t|
      t.string :item_nameid, null: false, index: true
      t.float :highest_buy_order, null: false, default: 0
      t.float :lowest_sell_order, null: false, default: 0
      t.integer :buy_order_number, null: false, default: 0
      t.integer :sell_order_number, null: false, default: 0

      t.timestamps null: false
    end
  end
end

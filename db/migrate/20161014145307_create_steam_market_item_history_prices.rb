class CreateSteamMarketItemHistoryPrices < ActiveRecord::Migration[5.0]
  def change
    create_table :steam_market_item_history_prices do |t|
      t.integer :app_id, null: false
      t.references :item, null: false
      t.integer :total_amount
      t.float :all_time_median
      t.integer :last_30_amount
      t.float :last_30_median
      t.integer :last_7_amount
      t.float :last_7_median
      t.integer :last_24h_amount
      t.float :last_24h_median
      t.datetime :fetched_at

      t.datetime :updated_at, null: false

      t.index [:app_id, :item_id], unique: true
    end
  end
end

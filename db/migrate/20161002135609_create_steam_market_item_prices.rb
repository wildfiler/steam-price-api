class CreateSteamMarketItemPrices < ActiveRecord::Migration[5.0]
  def change
    create_table :steam_market_item_prices do |t|
      t.string :name, null: false
      t.integer :volume, null: false
      t.money :lowest_price, null: false
      t.money :median_price, null: false
      t.string :currency, null: false
      t.text :response, null: false
      t.integer :response_code, null: false
      t.integer :app_id, null: false

      t.timestamps  null: false

      t.index [:app_id, :name]
      t.index :app_id
      t.index :name
    end
  end
end

class CreateSteamMarketItems < ActiveRecord::Migration[5.0]
  def change
    create_table :steam_market_items do |t|
      t.text :name, null: false, index: true
      t.integer :app_id, null: false

      t.timestamps null: false
      t.index [:app_id, :name], unique: true
    end
  end
end

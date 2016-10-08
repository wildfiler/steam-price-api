class AddItemNameidToSteamMarketItem < ActiveRecord::Migration[5.0]
  def change
    add_column :steam_market_items, :item_nameid, :string, index: true
  end
end

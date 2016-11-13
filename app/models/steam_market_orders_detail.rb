class SteamMarketOrdersDetail < ApplicationRecord
  validates :item_nameid, presence: true
end

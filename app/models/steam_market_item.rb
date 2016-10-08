class SteamMarketItem < ApplicationRecord
  validates :app_id, :name, presence: true
end

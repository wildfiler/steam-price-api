class SteamMarketItemPrice < ApplicationRecord
  validates :app_id, :name, :response, :response_code, :lowest_price, :median_price, :volume, :currency,
    presence: true
end

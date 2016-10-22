class SteamMarketItemHistoryPrice < ApplicationRecord
  belongs_to :item, class_name: 'SteamMarketItem'

  validates :app_id, :item_id, presence: true
  # validates :record_date, uniqueness: {
  #   scope: [:app_id, :item_name]
  # }
end

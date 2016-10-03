FactoryGirl.define do
  factory :steam_market_price_item do
    sequence(:name) { |n| "Item #{n}" }
    volume 1
    lowest_price "$100.99"
    median_price "$123.12"
    response '{"success":true,"lowest_price":"$100.99","volume":"1","median_price":"$123.12"}'
    code 200
    app_id 730
  end
end

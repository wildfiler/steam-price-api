class SteamMarketPriceImportJob
  include Sidekiq::Worker
  sidekiq_options queue: :import

  def perform(app_id, item_name, response, response_code)
    return if response_code.to_i != 200

    parsed_response = JSON.parse(response)
    lowest_price = parsed_response['lowest_price']
    median_price = parsed_response['median_price']
    volume = parsed_response['volume']
    currency = lowest_price.gsub(/[\d\.\,\s]/,'')

    SteamMarketItemPrice.create!(
      app_id: app_id.to_i,
      name: item_name,
      response: response,
      response_code: response_code,
      lowest_price: lowest_price,
      median_price: median_price,
      volume: volume,
      currency: currency
    )
  end
end

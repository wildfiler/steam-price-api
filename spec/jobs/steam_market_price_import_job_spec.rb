require 'rails_helper'

describe SteamMarketPriceImportJob, type: :job, sidekiq: :inline do
  it 'creates SteamMarketItemPrice' do
    app_id = 730
    item_name = 'Some Item'
    response = {
      lowest_price: '$123.23',
      volume: '123',
      median_price: '$100.12'
    }.to_json
    code = 200

    expect do
      SteamMarketPriceImportJob.perform_async(app_id, item_name, response, code)
    end.to change(SteamMarketItemPrice, :count).by 1

    price = SteamMarketItemPrice.last
    expect(price.lowest_price).to eq 123.23
    expect(price.median_price).to eq 100.12
    expect(price.volume).to eq 123
    expect(price.currency).to eq '$'
    expect(price.response_code).to eq 200
    expect(price.response).to eq response
    expect(price.app_id).to eq 730
  end

  context 'response code not 200' do
    it 'does not create SteamMarketItemPrice' do
      app_id = 123
      item_name = 'Some Item'
      response = '{"success":false}'
      code = 500

      expect do
        SteamMarketPriceImportJob.perform_async(app_id, item_name, response, code)
      end.not_to change(SteamMarketItemPrice, :count)
    end
  end
end

require 'rails_helper'

describe SteamMarketItemsImporter do
  it 'creates jobs for all items for game from steam market site' do
    app_id = 730

    query = {
      start: 0,
      count: 100,
      search_descriptions: 0,
      sort_column: 'name',
      sort_dir: 'asc',
      appid: app_id
    }

    body = File.read(Rails.root.join('spec', 'fixtures', 'items_list_page_0.html'))

    3.times do |start|
      expect(SteamMarketItemsFetchJob).to receive(:perform_async).
        with(app_id.to_s, (start * 100).to_s).and_call_original
    end

    stub_request(:get, "http://steamcommunity.com/market/search/render/").
      with(query: query).
      to_return(body: body, headers: {'Content-Type': 'application/json'})

    SteamMarketItemsImporter.new(app_id).import

    expect(WebMock).to have_requested(:get, 'http://steamcommunity.com/market/search/render/').
      with(query: query)

    expect(SteamMarketItemsFetchJob.jobs.size).to eq 3
  end
end

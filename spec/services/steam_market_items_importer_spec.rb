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

    items = (0...100).map { |n| "Item #{n}" }

    items.each_slice(20) do |items20|
      expect(SteamMarketPriceFetchJob).to receive(:perform_later).
        with(app_id.to_s, items20).at_least(3).times.and_call_original
    end

    3.times do |n|
      stub_request(:get, "http://steamcommunity.com/market/search/render/").
        with(
          query: query.merge(start: n * 100)
        ).
        to_return(
          body: body,
          headers: {'Content-Type' => 'application/json'}
        )
    end

    parser = instance_double(SteamMarketItemsImporter::Parser)
    allow(parser).to receive(:parse).and_return(items)

    SteamMarketItemsImporter.new(app_id, parser: parser).import

    3.times do |n|
      expect(WebMock).to have_requested(:get, 'http://steamcommunity.com/market/search/render/').
        with(
          query: query.merge(start: n * 100)
        )
    end

    expect(parser).to have_received(:parse).with(JSON.parse(body)['results_html']).exactly(3).times


    expect(SteamMarketPriceFetchJob).to have_been_enqueued.on_queue('fetch').exactly(15).times
  end
end

describe SteamMarketItemsImporter::Parser do
  let(:html) do
    <<~HTML
       	<div class="market_listing_table_header">
       		<div class="market_listing_price_listings_block">
       			<div class="market_listing_right_cell market_listing_their_price market_sortable_column" data-sorttype="price">PRICE<span class="market_sort_arrow" style="display:none;"></span></div>
       			<div class="market_listing_right_cell market_listing_num_listings market_sortable_column" data-sorttype="quantity">QUANTITY<span class="market_sort_arrow" style="display:none;"></span></div>
       			<div class="market_listing_right_cell market_listing_price_listings_combined market_sortable_column" data-sorttype="price">PRICE<span class="market_sort_arrow" style="display:none;"></span></div>
       		</div>
       				<div class="market_sortable_column" data-sorttype="name"><span class="market_listing_header_namespacer"></span>NAME<span class="market_sort_arrow" style="display:none;"></span></div>
       	</div>

        <a class="market_listing_row_link" href="http://steamcommunity.com/market/listings/730/AK-47%20%7C%20Aquamarine%20Revenge%20%28Battle-Scarred%29" id="resultlink_0">
          <div class="market_listing_row market_recent_listing_row market_listing_searchresult" id="result_0">
                <img id="result_0_image" src="http://steamcommunity-a.akamaihd.net/economy/image/-9a81dlWLwJ2UUGcVs_nsVtzdOEdtWwKGZZLQHTxDZ7I56KU0Zwwo4NUX4oFJZEHLbXH5ApeO4YmlhxYQknCRvCo04DEVlxkKgpot7HxfDhjxszJemkV09-5gZKKkPLLMrfFqWNU6dNoxL3H94qm3Ffm_RE6amn2ctWXdlI2ZwqB-FG_w-7s0ZK-7cjLzyE37HI8pSGKrIDGOAI/62fx62f" srcset="http://steamcommunity-a.akamaihd.net/economy/image/-9a81dlWLwJ2UUGcVs_nsVtzdOEdtWwKGZZLQHTxDZ7I56KU0Zwwo4NUX4oFJZEHLbXH5ApeO4YmlhxYQknCRvCo04DEVlxkKgpot7HxfDhjxszJemkV09-5gZKKkPLLMrfFqWNU6dNoxL3H94qm3Ffm_RE6amn2ctWXdlI2ZwqB-FG_w-7s0ZK-7cjLzyE37HI8pSGKrIDGOAI/62fx62f 1x, http://steamcommunity-a.akamaihd.net/economy/image/-9a81dlWLwJ2UUGcVs_nsVtzdOEdtWwKGZZLQHTxDZ7I56KU0Zwwo4NUX4oFJZEHLbXH5ApeO4YmlhxYQknCRvCo04DEVlxkKgpot7HxfDhjxszJemkV09-5gZKKkPLLMrfFqWNU6dNoxL3H94qm3Ffm_RE6amn2ctWXdlI2ZwqB-FG_w-7s0ZK-7cjLzyE37HI8pSGKrIDGOAI/62fx62fdpx2x 2x" style="border-color: #D2D2D2;" class="market_listing_item_img" alt="" />
                <div class="market_listing_price_listings_block">
              <div class="market_listing_right_cell market_listing_num_listings">
                <span class="market_table_value">
                  <span class="market_listing_num_listings_qty">106</span>
                </span>
              </div>
              <div class="market_listing_right_cell market_listing_their_price">
                <span class="market_table_value normal_price">
                  Starting at:<br/>
                  <span class="normal_price">$8.30 USD</span>
                  <span class="sale_price">$7.94 USD</span>
                </span>
                <span class="market_arrow_down" style="display: none"></span>
                <span class="market_arrow_up" style="display: none"></span>
              </div>
            </div>

                <div class="market_listing_item_name_block">
              <span id="result_0_name" class="market_listing_item_name" style="color: #D2D2D2;">AK-47 | Aquamarine Revenge (Battle-Scarred)</span>
              <br/>
              <span class="market_listing_game_name">Counter-Strike: Global Offensive</span>
            </div>
            <div style="clear: both"></div>
          </div>
        </a>

        <a class="market_listing_row_link" href="http://steamcommunity.com/market/listings/730/AK-47%20%7C%20Aquamarine%20Revenge%20%28Factory%20New%29" id="resultlink_1">
         	<div class="market_listing_row market_recent_listing_row market_listing_searchresult" id="result_1">
       				<img id="result_1_image" src="http://steamcommunity-a.akamaihd.net/economy/image/-9a81dlWLwJ2UUGcVs_nsVtzdOEdtWwKGZZLQHTxDZ7I56KU0Zwwo4NUX4oFJZEHLbXH5ApeO4YmlhxYQknCRvCo04DEVlxkKgpot7HxfDhjxszJemkV09-5gZKKkPLLMrfFqWdY781lxLuW8Njw31Dn8xc_YTqmJ4DDJFM2ZwqE_ATtx-u7g8C5vpjOzHM263E8pSGKJ1XuG9M/62fx62f" srcset="http://steamcommunity-a.akamaihd.net/economy/image/-9a81dlWLwJ2UUGcVs_nsVtzdOEdtWwKGZZLQHTxDZ7I56KU0Zwwo4NUX4oFJZEHLbXH5ApeO4YmlhxYQknCRvCo04DEVlxkKgpot7HxfDhjxszJemkV09-5gZKKkPLLMrfFqWdY781lxLuW8Njw31Dn8xc_YTqmJ4DDJFM2ZwqE_ATtx-u7g8C5vpjOzHM263E8pSGKJ1XuG9M/62fx62f 1x, http://steamcommunity-a.akamaihd.net/economy/image/-9a81dlWLwJ2UUGcVs_nsVtzdOEdtWwKGZZLQHTxDZ7I56KU0Zwwo4NUX4oFJZEHLbXH5ApeO4YmlhxYQknCRvCo04DEVlxkKgpot7HxfDhjxszJemkV09-5gZKKkPLLMrfFqWdY781lxLuW8Njw31Dn8xc_YTqmJ4DDJFM2ZwqE_ATtx-u7g8C5vpjOzHM263E8pSGKJ1XuG9M/62fx62fdpx2x 2x" style="border-color: #D2D2D2;" class="market_listing_item_img" alt="" />
       				<div class="market_listing_price_listings_block">
       			<div class="market_listing_right_cell market_listing_num_listings">
       				<span class="market_table_value">
       					<span class="market_listing_num_listings_qty">34</span>
       				</span>
       			</div>
       			<div class="market_listing_right_cell market_listing_their_price">
       				<span class="market_table_value normal_price">
       					Starting at:<br/>
       					<span class="normal_price">$32.67 USD</span>
       					<span class="sale_price">$31.25 USD</span>
       				</span>
       				<span class="market_arrow_down" style="display: none"></span>
       				<span class="market_arrow_up" style="display: none"></span>
       			</div>
       		</div>

       				<div class="market_listing_item_name_block">
       			<span id="result_1_name" class="market_listing_item_name" style="color: #D2D2D2;">AK-47 | Aquamarine Revenge (Factory New)</span>
       			<br/>
       			<span class="market_listing_game_name">Counter-Strike: Global Offensive</span>
       		</div>
       		<div style="clear: both"></div>
       	</div>
      </a>
    HTML
  end

  it 'parses html and returns item names' do
    parser = SteamMarketItemsImporter::Parser.new

    expect(parser.parse(html)).to match_array ['AK-47 | Aquamarine Revenge (Battle-Scarred)', 'AK-47 | Aquamarine Revenge (Factory New)']
  end
end


class SteamMarketItemsImporter

  def initialize(app_id, parser: SteamMarketItemsImporter::Parser.new)
    @app_id = app_id
    @parser = parser
  end

  def import
    query = {
      start: 0,
      count: 100,
      search_descriptions: 0,
      sort_column: 'name',
      sort_dir: 'asc',
      appid: @app_id
    }

    response = do_request(query)

    total_count = response['total_count']
    ((total_count - 100)/100.0).ceil.times do
      query[:start] += 100
      SteamMarketItemsFetchJob.perform_async(@app_id.to_s, query[:start].to_s)
    end

    parse_first_page(response)
  end

  def do_request(query)
    response = nil
    10.times do
      response = HTTParty.get('http://steamcommunity.com/market/search/render/', query: query)
      break if response.present?
      sleep 5
    end
    response.parsed_response
  end

  def parse_first_page(response)
    item_names = @parser.parse(response['results_html'])
    item_names.each do |item|
      begin
        SteamMarketItem.find_or_create_by(app_id: @app_id, name: item)
      rescue ActiveRecord::RecordNotUnique
        retry
      end
    end
  end

  class Parser
    def parse(html)
      page = Nokogiri::HTML(html)
      page.css('.market_listing_item_name').map(&:text)
    end
  end
end

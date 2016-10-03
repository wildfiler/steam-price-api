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
    response = HTTParty.get('http://steamcommunity.com/market/search/render/', query: query)
    parsed_response = response.parsed_response

    item_names = @parser.parse(parsed_response['results_html'])

    item_names.each_slice(20) do |items|
      SteamMarketPriceFetchJob.perform_async(@app_id.to_s, items)
    end

    total_count = parsed_response['total_count']

    ((total_count - 100)/100.0).ceil.times do
      query[:start] += 100
      response = nil
      20.times do
        response = HTTParty.get('http://steamcommunity.com/market/search/render/', query: query)
        break if response
        sleep 5
      end

      parsed_response = response.parsed_response

      item_names = @parser.parse(parsed_response['results_html'])

      item_names.each_slice(20) do |items|
        SteamMarketPriceFetchJob.perform_async(@app_id.to_s, items)
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

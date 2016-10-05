class SteamMarketItemsImporter

  def initialize(app_id)
    @app_id = app_id
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

    response = do_response(query)

    total_count = response['total_count']
    (total_count/100.0).ceil.times do
      SteamMarketItemsFetchJob.perform_async(@app_id.to_s, query[:start].to_s)
      query[:start] += 100
    end
  end

  def do_response(query)
    response = nil
    10.times do
      response = HTTParty.get('http://steamcommunity.com/market/search/render/', query: query)
      break if response.present?
      sleep 5
    end
    response.parsed_response
  end
end

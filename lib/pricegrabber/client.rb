module PriceGrabber
  class Client
    def initialize(api_key:, environment: :staging)
      @environment = environment
      @api_key = api_key
    end

    def find_by_id(asin: nil, upc: nil)
      Request.new(asin: asin, upc: upc, version: '2.55', pid: '1107', key: @api_key, environment: @environment)
    end

    def search(query)
      Request.new(q: query, upc: '1', version: '2.55', pid: '1107', key: @api_key, environment: @environment)
    end
  end
end

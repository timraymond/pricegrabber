require 'uri'
require 'httpi'

module PriceGrabber
  class Request
    attr_reader :environment

    def initialize(version:, pid:, key:, asin: nil, q: nil, masterid: nil, upc: nil, environment: :staging, driver: :net_http)
      @environment = environment
      @version = version
      @pid = pid
      @key = key
      @asin = asin
      @q = q
      @upc = upc
      @masterid = [*masterid]
      @driver = driver
      @wants = []
    end

    def to_uri
      uri = ::URI::HTTP.build({})
      uri.scheme = "http"
      if @environment == :production
        uri.host = "sws.pricegrabber.com"
      else
        uri.host = "sws.api.pricegrabber.com"
      end
      uri.path = "/search_xml.php"
      uri.query = [
        version,
        pid,
        key,
        asin,
        q,
        upc,
        masterid,
      ].compact.sort.join("&")
      uri
    end

    def to_s
      to_uri.to_s
    end

    def to_curl
      "curl -G '#{to_s}'"
    end

    def call
      request = HTTPI::Request.new
      request.url = to_s
      resp = HTTPI.get(request, @driver)
      PriceGrabber::Response.new(resp, @wants)
    end

    def pluck(*attributes)
      @wants = attributes.map(&:to_s)
      self
    end

    private

    def version
      "version=#{@version}"
    end

    def pid
      "pid=#{@pid}"
    end

    def key
      "key=#{@key}"
    end

    def asin
      if @asin
        "asin=#{@asin}"
      end
    end

    def q
      if @q
        "q=#{@q.gsub(/\s/, '+')}"
      end
    end

    def upc
      if @upc
        "upc=#{@upc}"
      end
    end

    def masterid
      case @masterid.length
      when 0
        nil
      when 1
        "masterid=#{@masterid.join(",")}"
      else
        "masterids=#{@masterid.join(",")}"
      end
    end
  end
end

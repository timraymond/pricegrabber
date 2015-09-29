require 'uri'
require 'httpi'
require 'nokogiri'

module PriceGrabber
  class Request
    def initialize(version:, pid:, key:, asin: nil, q: nil, masterid: nil, driver: :net_http)
      @version = version
      @pid = pid
      @key = key
      @asin = asin
      @q = q
      @masterid = [*masterid]
      @driver = driver
    end

    def to_uri
      uri = ::URI::HTTP.build({})
      uri.scheme = "http"
      uri.host = "sws.api.pricegrabber.com"
      uri.path = "/search_xml.php"
      uri.query = [
        version,
        pid,
        key,
        asin,
        q,
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
      case resp.code
      when 200
        result_set = []
        parser = Nokogiri::XML::SAX::Parser.new(ResponseHandler.new(@wants, result_set))
        parser.parse(resp.body)
        result_set
      when 500..600
        fail PriceGrabber::APIError
      end
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

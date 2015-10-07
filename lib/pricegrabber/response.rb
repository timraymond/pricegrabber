require 'active_support/core_ext/hash/conversions'
require 'pricegrabber/response_item'

module PriceGrabber
  # Represents a response from the PriceGrabber API.
  class Response
    include Enumerable
    # @param response [HTTPI::Response] The XML response from Pricegrabber's API
    # @param wants [Array<String>] Attributes from the response that should be made available within this response
    def initialize(response, wants)
      @status = response.code
      resp_hash = Hash.from_xml(response.body)
      @error = resp_hash["document"]["error"]
      @results = []
      [resp_hash["document"]["product"]].flatten.each do |product|
        curr_result = ResponseItem.with_attributes(wants)
        wants.map do |want|
          parts = want.split(".")
          curr = parts.shift
          curr_value = product
          while curr && curr_value
            curr_value = curr_value[curr]
            curr = parts.shift
          end

          curr_result.public_send(:"#{want.tr(".", "_")}=", curr_value)
        end
        @results << curr_result
      end
    end

    def each(*args, &block)
      @results.each(*args, &block)
    end

    def successful?
      @status < 300 && @status >= 200 && @error == nil
    end
  end
end

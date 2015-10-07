require 'spec_helper'

describe PriceGrabber::Response do
  let(:valid_xml) do
    <<-XML
    <document>
      <product>
        <title>Super Soaker</title>
        <offer>
          <retailer>Amazon</retailer>
          <price>$1337.00</price>
        </offer>
      </product>
    </document>
    XML
  end

  let(:error_xml) do
    <<-XML
    <document>
      <error>There was an error</error>
    </document>
    XML
  end

  context 'with valid response JSON' do
    before do
      http_resp = HTTPI::Response.new(200, {}, valid_xml)
      @response = described_class.new(http_resp, ["offer.retailer", "offer.price"])
    end

    it 'reports that it is a successful response' do
      expect(@response.successful?).to eq(true)
    end

    it 'makes response items available as underscorized methods' do
      @response.each do |item|
        expect(item.offer_price).to eq("$1337.00")
        expect(item.offer_retailer).to eq("Amazon")
      end
    end
  end

  context 'with error JSON and 200 response code' do
    it 'reports that the request was unsuccessful' do
      http_resp = HTTPI::Response.new(200, {}, error_xml)
      response = described_class.new(http_resp, ["offer.retailer", "offer.price"])
      expect(response.successful?).to eq(false)
    end
  end
end

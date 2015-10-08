require 'spec_helper'

describe PriceGrabber::Response do
  let(:valid_xml) do
    <<-XML
    <?xml version="1.0"?>
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
    <?xml version="1.0"?>
    <document>
      <error>There was an error</error>
    </document>
    XML
  end

  let(:no_offers) do
    <<-XML
    <?xml version="1.0"?>
    <document>
      <product>
        <title>Super Soaker</title>
      </product>
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

  context 'with no offers for a product' do
    context 'when asking for only offer fields' do
      it 'iterates zero times' do
        http_resp = HTTPI::Response.new(200, {}, no_offers)
        response = described_class.new(http_resp, ["offer.retailer", "offer.price"])
        counter = 0
        response.each do
          counter += 1
        end
        expect(counter).to eq(0)
      end
    end

    context 'when asking for product and offer fields' do
      it 'iterates over found results' do
        http_resp = HTTPI::Response.new(200, {}, no_offers)
        response = described_class.new(http_resp, ["title", "offer.price"])
        counter = 0
        response.each do
          counter += 1
        end
        expect(counter).to eq(1)
      end
    end
  end
end

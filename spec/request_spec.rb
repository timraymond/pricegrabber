require 'spec_helper'

describe PriceGrabber::Request do
  describe 'url construction' do
    it 'produces the correct URL for a given ASIN' do
      req = described_class.new(version: '2.55', pid: '1107', key: '123456', asin: 'B007ARLMI0')
      expect(req.to_s).to eq('http://sws.api.pricegrabber.com/search_xml.php?asin=B007ARLMI0&key=123456&pid=1107&version=2.55')
    end

    describe 'full text queries' do
      it 'constructs urls for full text queries' do
        req = described_class.new(version: '2.55', pid: '1107', key: '123456', q: 'wool sweater')
        expect(req.to_s).to eq('http://sws.api.pricegrabber.com/search_xml.php?key=123456&pid=1107&q=wool+sweater&version=2.55')
      end
    end

    describe 'masterid' do
      it 'constructs queries for masterids' do
        req = described_class.new(version: '2.55', pid: '1107', key: '123456', masterid: '67360634')
        expect(req.to_s).to eq('http://sws.api.pricegrabber.com/search_xml.php?key=123456&masterid=67360634&pid=1107&version=2.55')
      end

      it 'constructs queries for multiple masterids' do
        req = described_class.new(version: '2.55', pid: '1107', key: '123456', masterid: ['24239727', '12721949'])
        expect(req.to_s).to eq('http://sws.api.pricegrabber.com/search_xml.php?key=123456&masterids=24239727,12721949&pid=1107&version=2.55')
      end
    end

    it 'provides to_curl for debugging purposes' do
      req = described_class.new(version: '2.55', pid: '1107', key: '123456', asin: 'B007ARLMI0')
      expect(req.to_curl).to eq('curl -G \'http://sws.api.pricegrabber.com/search_xml.php?asin=B007ARLMI0&key=123456&pid=1107&version=2.55\'')
    end
  end

  describe 'query execution' do
    it 'returns an enumerable' do
      req = described_class.new(version: '2.55', pid: '1107', key: '123456', asin: 'B007ARLMI0', driver: :mock_driver)
      expect(req.call.class < Enumerable).to eq(true)
    end

    it "allows attribute plucking" do
      expect_any_instance_of(PriceGrabber::ResponseHandler).to receive(:initialize).with(['name', 'price'], [])
      req = described_class.new(version: '2.55', pid: '1107', key: '123456', asin: 'B007ARLMI0', driver: :mock_driver).pluck(:name, :price)
      req.call
    end
  end
end

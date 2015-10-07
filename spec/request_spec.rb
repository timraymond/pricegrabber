require 'spec_helper'

describe PriceGrabber::Request do
  describe 'url construction' do
    it 'produces the correct URL for a given ASIN' do
      req = described_class.new(version: '2.55', pid: '8675309', key: '123456', asin: 'B007ARLMI0')
      expect(req.to_s).to eq('http://sws.api.pricegrabber.com/search_xml.php?asin=B007ARLMI0&key=123456&pid=8675309&version=2.55')
    end

    describe 'full text queries' do
      it 'constructs urls for full text queries' do
        req = described_class.new(version: '2.55', pid: '8675309', key: '123456', q: 'wool sweater')
        expect(req.to_s).to eq('http://sws.api.pricegrabber.com/search_xml.php?key=123456&pid=8675309&q=wool+sweater&version=2.55')
      end
    end

    describe 'masterid' do
      it 'constructs queries for masterids' do
        req = described_class.new(version: '2.55', pid: '8675309', key: '123456', masterid: '67360634')
        expect(req.to_s).to eq('http://sws.api.pricegrabber.com/search_xml.php?key=123456&masterid=67360634&pid=8675309&version=2.55')
      end

      it 'constructs queries for multiple masterids' do
        req = described_class.new(version: '2.55', pid: '8675309', key: '123456', masterid: ['24239727', '12721949'])
        expect(req.to_s).to eq('http://sws.api.pricegrabber.com/search_xml.php?key=123456&masterids=24239727,12721949&pid=8675309&version=2.55')
      end
    end

    it 'constructs queries for UPCs' do
      req = described_class.new(version: '2.55', pid: '8675309', key: '123456', upc: '004815162342')
      expect(req.to_s).to eq('http://sws.api.pricegrabber.com/search_xml.php?key=123456&pid=8675309&upc=004815162342&version=2.55')
    end

    it 'provides to_curl for debugging purposes' do
      req = described_class.new(version: '2.55', pid: '8675309', key: '123456', asin: 'B007ARLMI0')
      expect(req.to_curl).to eq('curl -G \'http://sws.api.pricegrabber.com/search_xml.php?asin=B007ARLMI0&key=123456&pid=8675309&version=2.55\'')
    end
  end

  describe 'query execution' do
    it 'returns an enumerable' do
      req = described_class.new(version: '2.55', pid: '8675309', key: '123456', asin: 'B007ARLMI0', driver: :mock_driver)
      expect(req.call.class < Enumerable).to eq(true)
    end

    it "allows attribute plucking" do
      req = described_class.new(version: '2.55', pid: '8675309', key: '123456', asin: 'B007ARLMI0', driver: :mock_driver).pluck(:title, :url)
      resp = req.call.first
      expect(resp.title).to eq("S23B300B 23-inch LED LCD Monitor with MagicAngle - 1920 x 1080 - 1000:1 - 250 cd/m2 - 5 ms - DVI/VGA - Black")
      expect(resp.url).to eq("http://reviewed.api.pgpartner.com/mrdr.php?url=http%3A%2F%2Freviewed.api.pgpartner.com%2Fsearch_getprod.php%3Fmasterid%3D962261805")
    end
  end
end

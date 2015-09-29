class MockDriver < HTTPI::Adapter::Base
  register :mock_driver, deps: []

  def initialize(request)
  end

  def request(method)
    content = <<-XML_MOCK
    <?xml version="1.0"?>
    <document xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.pricegrabber.com/pg_2.55.xsd"><version>2.55</version><api_request_id>ee316cb2ed8561676ea97592d86afdf2</api_request_id><num_results>1</num_results><pricegrabber_url>http://www.api.pricegrabber.com/computers/monitors++samsung-s23b300b-23-inch-led-lcd-monitor-with-magicangle-1920-x-1080-1/m-962261805/</pricegrabber_url><pricegrabber_url_text>Samsung S23B300B 23-inch LED LCD Monitor with MagicAngle - 1920 x 1080 - 1000:1 - 250 cd/m2 - 5 ms - DVI/VGA - Black by PriceGrabber.com</pricegrabber_url_text><partner_url>http://reviewed.api.pgpartner.com</partner_url><market>us</market><product><url>http://reviewed.api.pgpartner.com/mrdr.php?url=http%3A%2F%2Freviewed.api.pgpartner.com%2Fsearch_getprod.php%3Fmasterid%3D962261805</url><masterid>962261805</masterid><title>S23B300B 23-inch LED LCD Monitor with MagicAngle - 1920 x 1080 - 1000:1 - 250 cd/m2 - 5 ms - DVI/VGA - Black</title><title_short>S23B300B 23-inch LED LCD Monitor with MagicAngle - 1920 x 1080 - 1000:1 - 250 cd/m2 - 5 ms - DVI/VGA - Black</title_short><image_small>http://d3vv6xw699rjh3.cloudfront.net/80e0b4-962261805_1_50.jpg</image_small><image_medium>http://d3vv6xw699rjh3.cloudfront.net/458cd9-962261805_1_75.jpg</image_medium><image_large>http://d3vv6xw699rjh3.cloudfront.net/0e11ab-962261805_1_125.jpg</image_large><image_160>http://d3vv6xw699rjh3.cloudfront.net/3f24e8-962261805_1_160.jpg</image_160><has_image>y</has_image><manufacturer>Samsung</manufacturer><partnum>S23B300B</partnum><upc>0729507818801</upc><topcat id="1">Computers</topcat><catzero id="3">Monitors</catzero><page id="37">Monitors</page><num_reviews>0</num_reviews><rating>0.00</rating><rating_image>
    </rating_image><price sellers="1" qlty="all">$250.51</price><price qlty="r">$250.51</price><num_sellers qlty="all" desc="All">1</num_sellers><num_sellers qlty="r" desc="Refurbished">1</num_sellers></product></document>
    XML_MOCK

    HTTPI::Response.new(200, {"Content-Type" => "text/xml;charset=UTF-8"}, content)
  end
end


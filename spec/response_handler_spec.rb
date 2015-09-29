require 'spec_helper'

describe PriceGrabber::ResponseHandler do

  it 'is a Nokogiri SAXHandler' do
    expect(described_class < Nokogiri::XML::SAX::Document).to eq(true)
  end

  it 'builds a response set with a set of wants when encountering elements' do
    results = []
    handler = described_class.new(['name', 'price'], results)

    handler.start_document

    handler.start_element "product"

    handler.start_element "name"
    handler.characters "Rare Candy"
    handler.end_element "name"

    handler.start_element "price"
    handler.characters "12345 Credits"
    handler.end_element "price"

    handler.end_element "product"

    handler.end_document

    expect(results.first).to eq({:name => "Rare Candy", :price => "12345 Credits"})
  end
end

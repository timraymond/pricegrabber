require 'spec_helper'

describe PriceGrabber::Client do
  it 'has a search method' do
    grabber = described_class.new(api_key: '1234')
    expect(grabber).to respond_to(:search)
  end

  it 'generates production requests for id requests' do
    grabber = described_class.new(api_key: '1234', environment: :production)
    req = grabber.find_by_id(asin: "B00YAH")
    expect(req.environment).to eq(:production)
  end

  it 'generates production requests for searches' do
    grabber = described_class.new(api_key: '1234', environment: :production)
    req = grabber.search("Canon Camera")
    expect(req.environment).to eq(:production)
  end
end

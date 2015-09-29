require 'spec_helper'

describe PriceGrabber::Client do
  it 'has a search method' do
    grabber = described_class.new(api_key: '1234')
    expect(grabber).to respond_to(:search)
  end
end

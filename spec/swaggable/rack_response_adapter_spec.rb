require_relative '../spec_helper'

RSpec.describe Swaggable::RackResponseAdapter do
  subject { Swaggable::RackResponseAdapter.new rack_request }
  let(:rack_request) { [200, {}, []] }

  describe '#content_type' do
    it 'returns CONTENT_TYPE' do
      rack_request[1]['Content-Type'] = 'application/xml'
      expect(subject.content_type).to eq 'application/xml'
    end

    it 'can be set' do
      subject.content_type = 'application/xml'
      expect(subject.content_type).to eq 'application/xml'
    end
  end

  describe '#code' do
    it 'returns the request status code' do
      rack_request[0] = 418
      expect(subject.code).to eq 418
    end

    it 'can be set' do
      subject.code = 418
      expect(subject.code).to eq 418
    end
  end
end

require_relative '../spec_helper'

RSpec.describe Swaggable::RackResponseAdapter do
  let(:subject_class) { Swaggable::RackResponseAdapter }
  subject { subject_class.new rack_request }
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

  describe '#==' do
    it 'equals by rack request' do
      subject_1 = subject_class.new([418, {some: :header}, ['some body']])
      subject_2 = subject_class.new([418, {some: :header}, ['some body']])
      subject_3 = subject_class.new([418, {some: :header}, ['different body']])

      expect(subject_1 == subject_2).to be true
      expect(subject_1 == subject_3).to be false
    end

    it 'doesn\'t throw error if comparing with any random object' do
      expect{ subject == double }.not_to raise_error
    end
  end
end

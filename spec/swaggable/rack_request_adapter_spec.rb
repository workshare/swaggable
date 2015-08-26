require_relative '../spec_helper'

RSpec.describe Swaggable::RackRequestAdapter do
  subject { Swaggable::RackRequestAdapter.new env }
  let(:env) { {} }

  it 'allows accessing the original env hash' do
    subject = described_class.new('CONTENT_TYPE' => 'application/json')
    expect(subject['CONTENT_TYPE']).to eq 'application/json'
  end

  describe '#query_parameters' do
    it 'parses the query string' do
      env['QUERY_STRING'] = 'a=1&b=2'
      expect(subject.query_parameters).to eq('a' => '1', 'b' => '2')
    end

    it 'can be updated' do
      env['QUERY_STRING'] = 'a=1'
      subject.query_parameters['b'] = 2
      expect(subject.query_parameters).to eq('a' => '1', 'b' => '2')
    end


    it 'can be assigned' do
      subject.query_parameters = {a: 1, b: 2}
      expect(subject.query_parameters).to eq('a' => '1', 'b' => '2')
    end

    it 'works with unicode'
    it 'works with scaped chars'
  end

  describe '#path' do
    it 'returns PATH_INFO' do
      subject = described_class.new('PATH_INFO' => '/test')
      expect(subject.path).to eq '/test'
    end
  end

  describe '#parameters' do
    it 'includes query_parameters' do
      env['QUERY_STRING'] = 'a=1&b=2'
      expect(subject.parameters).to eq('a' => '1', 'b' => '2')
    end

    it 'includes path_parameters'
    it 'includes form_parameters'
    it 'includes header_parameters' # Makes sense?
  end

  describe '#body' do
    it 'is the body of the request' do
      env['rack.input'] = double(:body_stream, read: 'the body')
      expect(subject.body).to eq 'the body'
    end
  end

  describe '#parsed_body' do
    it 'can be JSON' do
      env['rack.input'] = double(:body_stream, read: '{"name":"John"}')
      env['CONTENT_TYPE'] = 'application/json'

      expect(subject.parsed_body).to eq({'name' => 'John'})
    end
  end
end

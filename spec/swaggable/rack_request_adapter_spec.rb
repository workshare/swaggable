require_relative '../spec_helper'

RSpec.describe Swaggable::RackRequestAdapter do
  subject { Swaggable::RackRequestAdapter.new env }
  let(:env) { {} }

  it 'allows accessing the original env hash' do
    subject = described_class.new('CONTENT_TYPE' => 'application/json')
    expect(subject['CONTENT_TYPE']).to eq 'application/json'
  end

  describe '#query_params' do
    it 'parses the query string' do
      env['QUERY_STRING'] = 'a=1&b=2'
      expect(subject.query_params).to eq('a' => '1', 'b' => '2')
    end

    it 'can be updated' do
      env['QUERY_STRING'] = 'a=1'
      subject.query_params['b'] = 2
      expect(subject.query_params).to eq('a' => '1', 'b' => '2')
    end


    it 'can be assigned' do
      subject.query_params = {a: 1, b: 2}
      expect(subject.query_params).to eq('a' => '1', 'b' => '2')
    end

    it 'works with unicode'
    it 'works with scaped chars'
  end

  describe '#params' do
    it 'includes query_params' do
      env['QUERY_STRING'] = 'a=1&b=2'
      expect(subject.params).to eq('a' => '1', 'b' => '2')
    end

    it 'includes path_params'
    it 'includes form_params'
    it 'includes header_params' # Makes sense?
    it 'includes body_params' # Makes sense?
  end
end

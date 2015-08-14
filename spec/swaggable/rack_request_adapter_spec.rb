require_relative '../spec_helper'

RSpec.describe Swaggable::RackRequestAdapter do
  subject { Swaggable::RackRequestAdapter.new env }
  let(:env) { {} }

  it 'allows accessing the original env hash' do
    subject = described_class.new('CONTENT_TYPE' => 'application/json')
    expect(subject['CONTENT_TYPE']).to eq 'application/json'
  end
end

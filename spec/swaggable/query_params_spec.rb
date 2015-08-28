require_relative '../spec_helper'

RSpec.describe 'Swaggable::QueryParams' do
  subject { subject_class.new }
  let(:subject_class) { Swaggable::QueryParams }

  it 'parses the query string' do
    subject.string = 'a=1&b=2'
    expect(subject).to eq('a' => '1', 'b' => '2')
  end

  it 'can be updated' do
    subject.string = 'a=1'
    subject['b'] = 2
    expect(subject).to eq('a' => '1', 'b' => '2')
  end

  it 'can initialized with a hash' do
    subject = subject_class.new a: 1, b: 2
    expect(subject).to eq('a' => '1', 'b' => '2')
  end

  it 'works with unicode' do
    subject.string = "person=\u2713"
    expect(subject).to eq('person' => "\u2713")
  end

  it 'works with scaped chars in the string' do
    subject.string = 'name=john%20smith'
    expect(subject).to eq('name' => 'john smith')
  end

  it 'works with scaped chars in the hash' do
    subject['name'] = 'john smith'
    expect(subject.string).to eq 'name=john+smith'
  end
end

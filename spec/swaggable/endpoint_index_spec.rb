require_relative '../spec_helper'

RSpec.describe 'IndexedList' do
  let(:subject_class) { Swaggable::IndexedList }

  let(:subject_instance) do
    subject_class.new.tap do |l|
      l.key {|e| e.name }
      l.build { OpenStruct.new }
    end
  end

  subject { subject_instance }

  it 'accumulates values with <<' do
    value = double('value', name: 'Value 1')
    subject << value
    expect(subject['Value 1']).to be value
  end

  it 'accumulates values with add' do
    value = double('value', name: 'Value 1')
    subject.add value
    expect(subject['Value 1']).to be value
  end

  it 'adds new values' do
    value = subject.add_new do |e|
      e.name = 'Value 1'
    end

    expect(subject['Value 1']).to be value
  end

  it 'iterates through values' do
    has_run = false

    value = subject.add_new do |e|
      e.name = 'Value 1'
    end

    subject.each do |e|
      has_run = true
      expect(e).to be value
    end
  end

  it 'converts to array' do
    value = subject.add_new do |e|
      e.name = 'Value 1'
    end

    expect(subject.to_a).to eq [value]
  end

  it 'clears' do
    value = subject.add_new do |e|
      e.name = 'Value 1'
    end

    subject.clear

    expect(subject.to_a).to eq []
  end
end

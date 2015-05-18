require_relative '../spec_helper'

RSpec.describe 'Swaggable::TagDefinition' do
  let(:subject_class) { Swaggable::TagDefinition }
  let(:subject_instance) { Swaggable::TagDefinition.new }
  subject { subject_instance }

  it 'has a name' do
    subject.name = 'a name'
    expect(subject.name).to eq  'a name'
  end

  it 'has a description' do
    subject.description = 'a new desc'
    expect(subject.description).to eq  'a new desc'
  end

  it 'yields itself on initialize' do
    yielded = false

    subject_class.new do |s|
      expect(s).to be_a subject_class
      yielded = true
    end

    expect(yielded).to be true
  end
end

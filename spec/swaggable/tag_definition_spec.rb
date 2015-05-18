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

  it 'equals by name' do
    tag_1 = subject_class.new name: 'tag 1', description: 'Desc 1'
    tag_1_again = subject_class.new name: 'tag 1', description: 'Desc 1 again'
    tag_2 = subject_class.new name: 'tag 2', description: 'Desc 2'

    expect(tag_1).to eq tag_1_again
    expect(tag_1).not_to eq tag_2
  end

  it 'accepts attributes on initialize' do
    tag = subject_class.new name: 'New name', description: 'New description'
    expect(tag.name).to eq 'New name'
    expect(tag.description).to eq 'New description'
  end
end

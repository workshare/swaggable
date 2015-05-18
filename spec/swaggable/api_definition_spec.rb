require_relative '../spec_helper'

RSpec.describe 'Swaggable::ApiDefinition' do
  let(:subject_class) { Swaggable::ApiDefinition }
  let(:subject_instance) { Swaggable::ApiDefinition.new }
  subject { subject_instance }

  it 'has a version' do
    subject.version = 'v2.0'
    expect(subject.version).to eq  'v2.0'
  end

  it 'has a title' do
    subject.title = 'a new title'
    expect(subject.title).to eq  'a new title'
  end

  it 'has a description' do
    subject.description = 'a new description'
    expect(subject.description).to eq  'a new description'
  end

  it 'has a base_path' do
    subject.base_path = 'a new base_path'
    expect(subject.base_path).to eq  'a new base_path'
  end

  it 'has endpoints' do
    endpoint = double('endpoint')
    subject.endpoints << endpoint
    expect(subject.endpoints).to eq  [endpoint]
  end

  it 'has tags' do
    pending 'They should be collected from endpoints'
    raise 'NotImplementedError'
    tag = double('tag')
    subject.tags << tag
    expect(subject.tags).to eq  [tag]
  end

  it 'yields itself on initialize' do
    yielded = false

    subject_class.new do |s|
      expect(s).to be_a subject_class
      yielded = true
    end

    expect(yielded).to be true
  end

  it 'builds from a Grape API' do
    pending
    subject_class.from_grape_api double()
  end
end

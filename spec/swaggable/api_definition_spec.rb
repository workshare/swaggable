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
    endpoint = instance_double(Swaggable::EndpointDefinition)
    subject.endpoints << endpoint
    expect(subject.endpoints).to eq  [endpoint]
  end

  describe '#tags' do
    it 'is collected from endpoints' do
      tag = instance_double(Swaggable::TagDefinition)
      endpoint = instance_double(Swaggable::EndpointDefinition, tags: [tag])
      subject.endpoints << endpoint
      expect(subject.tags).to eq [tag]
    end

    it 'avoids duplicates' do
      tag_1 = instance_double(Swaggable::TagDefinition)
      tag_2 = instance_double(Swaggable::TagDefinition)

      endpoint_a = instance_double(Swaggable::EndpointDefinition, tags: [tag_1, tag_2])
      endpoint_b = instance_double(Swaggable::EndpointDefinition, tags: [tag_1])

      subject.endpoints << endpoint_a
      subject.endpoints << endpoint_b

      expect(subject.tags).to eq [tag_1, tag_2]
    end

    it 'is empty array when no tags are present' do
      subject.endpoints.clear
      expect(subject.tags).to eq []
    end
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
    allow(subject_class.grape_adapter).to receive(:import) { |api, grape| api.title = 'A test'; api }
    result = subject_class.from_grape_api double('grape')
    expect(result.title).to eq 'A test'
  end
end

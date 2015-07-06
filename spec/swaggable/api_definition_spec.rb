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
    endpoint = Swaggable::EndpointDefinition.new verb: :get, path: '/'
    subject.endpoints << endpoint
    expect(subject.endpoints.first).to eq endpoint
  end

  describe '#endpoints' do
    subject { subject_instance.endpoints }

    it 'accumulates endpoints with <<' do
      endpoint = Swaggable::EndpointDefinition.new verb: :get, path: '/'
      subject << endpoint
      expect(subject['GET /']).to be endpoint
    end

    it 'accumulates endpoints with add' do
      endpoint = Swaggable::EndpointDefinition.new verb: :get, path: '/'
      subject.add endpoint
      expect(subject['GET /']).to be endpoint
    end

    it 'adds new endpoints' do
      endpoint = subject.add_new do |e|
        e.verb = :post
        e.path = '/users'
      end

      expect(subject['POST /users']).to be endpoint
    end

    it 'iterates through endpoints' do
      has_run = false

      endpoint = subject.add_new do |e|
        e.verb = :post
        e.path = '/users'
      end

      subject.each do |e|
        has_run = true
        expect(e).to be endpoint
      end
    end

    it 'converts to array' do
      endpoint = subject.add_new do |e|
        e.verb = :post
        e.path = '/users'
      end

      expect(subject.to_a).to eq [endpoint]
    end

    it 'clears' do
      endpoint = subject.add_new do |e|
        e.verb = :post
        e.path = '/users'
      end

      subject.clear

      expect(subject.to_a).to eq []
    end
  end

  describe '#tags' do
    it 'is collected from endpoints' do
      tag = instance_double(Swaggable::TagDefinition, name: 'A tag')
      endpoint = Swaggable::EndpointDefinition.new verb: :get, path: '/'
      endpoint.tags << tag
      subject.endpoints << endpoint
      expect(subject.tags.first).to eq tag
    end

    it 'avoids duplicates' do
      tag_1 = Swaggable::TagDefinition.new name: 'tag_1'
      tag_1_again = Swaggable::TagDefinition.new name: 'tag_1'
      tag_2 = Swaggable::TagDefinition.new name: 'tag_2'

      endpoint_a = Swaggable::EndpointDefinition.new
      endpoint_b = Swaggable::EndpointDefinition.new

      endpoint_a.tags << tag_1
      endpoint_b.tags << tag_1_again
      endpoint_b.tags << tag_2

      subject.endpoints << endpoint_a
      subject.endpoints << endpoint_b

      expect(subject.tags.to_a).to eq [tag_1_again, tag_2]
    end

    it 'is empty array when no tags are present' do
      subject.endpoints.clear
      expect(subject.tags).to eq []
    end

    it 'is frozen to avoid giving the false impression that it can be modified' do
      expect{ subject.tags << instance_double(Swaggable::TagDefinition) }.to raise_error(RuntimeError)
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
    allow(subject_class.grape_adapter).to receive(:import) { |grape, api| api.title = 'A test'; api }
    result = subject_class.from_grape_api double('grape')
    expect(result.title).to eq 'A test'
  end

  it 'has a dsl' do
    api = Swaggable::ApiDefinition.new

    api.configure do
      version 'v1.0'
      title 'My API'
      description 'My cool API'
      base_path '/a/path'

      endpoints do
        add_new do
          path '/users'
          verb :post
          description 'Creates users'
          summary 'Allows to create an user'
        end
      end
    end

    expect(api.version).to eq 'v1.0'
    expect(api.endpoints.first.path).to eq '/users'
  end
end

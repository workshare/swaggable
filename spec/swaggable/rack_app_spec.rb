require_relative '../spec_helper'
require 'rack/test'

RSpec.describe 'Swaggable::RackApp' do
  include Rack::Test::Methods

  let(:subject_class) { Swaggable::RackApp }
  let(:subject_instance) { Swaggable::RackApp.new serializer: serializer, api_definition: api_definition }
  subject { subject_instance }
  let(:api_definition) { instance_double(Swaggable::ApiDefinition) }
  let(:serializer) { instance_double(Swaggable::Swagger2Serializer, serialize: {}) }

  def app
    subject_instance
  end

  it 'has status 200 OK' do
    get '/'
    expect(last_response.status).to eq 200
  end

  it 'has content_type application/json' do
    get '/'
    expect(last_response.headers['Content-Type']).to eq 'application/json'
  end

  it 'has body the serialized swagger' do
    allow(serializer).to receive(:serialize).with(api_definition).and_return({some: :json})

    get '/'
    expect(last_response.body).to eq '{"some":"json"}'
  end

  it 'uses Swagger2Serializer by default' do
    subject = subject_class.new
    expect(subject.serializer).to be_a Swaggable::Swagger2Serializer
  end

  describe 'validate!' do
    it 'validates against the serializer' do
      expect(serializer).
        to receive(:validate!).
        with api_definition

      subject.validate!
    end
  end

  describe 'validate' do
    it 'validates against the serializer' do
      expect(serializer).
        to receive(:validate).
        with api_definition

      subject.validate
    end
  end
end


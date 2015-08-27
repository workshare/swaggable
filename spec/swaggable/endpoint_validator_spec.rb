require_relative '../spec_helper'
require 'rack'

RSpec.describe 'Swaggable::EndpointValidator' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new endpoint: endpoint_definition, request: request }
  let(:subject_class) { Swaggable::EndpointValidator }
  let(:request) { request_for :get, '/existing_endpoint' }
  let(:response) { [200, {}, []] }
  let(:endpoint_definition) { api_definition.endpoints.first }
  let(:some_error) { double('some_error') }
  let(:endpoint) { api_definition.endpoints.first }

  let :api_definition do
    Swaggable::ApiDefinition.new do
      endpoints.add_new do
        path '/existing_endpoint'
        verb :get
      end
    end
  end

  def request_for verb, path
    Swaggable::RackRequestAdapter.new Rack::MockRequest.env_for path, 'REQUEST_METHOD' => verb
  end

  before do
    allow(Swaggable::CheckMandatoryParameters).to receive(:call).and_return([])
    allow(Swaggable::CheckExpectedParameters).to receive(:call).and_return([])
    allow(Swaggable::CheckRequestContentType).to receive(:call).and_return([])

    allow(Swaggable::CheckResponseContentType).to receive(:call).and_return([])
  end

  describe '#errors_for_request(request)' do
    it 'is empty when all is correct' do
      expect(subject.errors_for_request(request)).to be_empty
    end

    it 'validates the content type' do
      allow(Swaggable::CheckRequestContentType).
        to receive(:call).
        with(endpoint: endpoint, request: request).
        and_return([some_error])

      expect(subject.errors_for_request(request)).to include(some_error)
    end

    it 'validates all mandatory parameters are present' do
      allow(Swaggable::CheckMandatoryParameters).
        to receive(:call).
        with(endpoint: endpoint, request: request).
        and_return([some_error])

      expect(subject.errors_for_request(request)).to include(some_error)
    end

    it 'validates expected parameters' do
      allow(Swaggable::CheckExpectedParameters).
        to receive(:call).
        with(endpoint: endpoint, request: request).
        and_return([some_error])

      expect(subject.errors_for_request(request)).to include(some_error)
    end

    it 'validates body schema' do
      body = endpoint.parameters.add_new { location :body }

      allow(Swaggable::CheckBodySchema).
        to receive(:call).
        with(endpoint: endpoint, request: request).
        and_return([some_error])

      expect(subject.errors_for_request(request)).to include(some_error)
    end
  end

  describe '#errors_for_response(response)' do
    it 'validates content type' do
      allow(Swaggable::CheckResponseContentType).
        to receive(:call).
        with(endpoint: endpoint, response: response).
        and_return([some_error])

      expect(subject.errors_for_response(response)).to include(some_error)
    end

    it 'validates response body'
    it 'validates status code'
  end
end

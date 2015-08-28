require_relative '../spec_helper'
require 'rack'

RSpec.describe 'Swaggable::EndpointValidator' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new endpoint: endpoint_definition, request: request }
  let(:subject_class) { Swaggable::EndpointValidator }
  let(:request) { request_for :get, '/existing_endpoint' }
  let(:response) { Swaggable::RackResponseAdapter.new [200, {}, []] }
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

  describe '#errors_for_request(request)' do
    def returns_some_error check
      allow(check).to receive(:call).
        with(endpoint: endpoint, request: request).
        and_return([some_error])
    end

    def returns_no_error check
      allow(check).to receive(:call).
        with(endpoint: endpoint, request: request).
        and_return([])
    end

    before do
      returns_no_error Swaggable::CheckMandatoryParameters
      returns_no_error Swaggable::CheckExpectedParameters
      returns_no_error Swaggable::CheckRequestContentType
    end

    it 'is empty when all is correct' do
      expect(subject.errors_for_request(request)).to be_empty
    end

    it 'validates the content type' do
      returns_some_error Swaggable::CheckRequestContentType
      expect(subject.errors_for_request(request)).to include(some_error)
    end

    it 'validates all mandatory parameters are present' do
      returns_some_error Swaggable::CheckMandatoryParameters
      expect(subject.errors_for_request(request)).to include(some_error)
    end

    it 'validates expected parameters' do
      returns_some_error Swaggable::CheckExpectedParameters
      expect(subject.errors_for_request(request)).to include(some_error)
    end

    it 'validates body schema' do
      body = endpoint.parameters.add_new { location :body }
      returns_some_error Swaggable::CheckBodySchema
      expect(subject.errors_for_request(request)).to include(some_error)
    end
  end

  describe '#errors_for_response(response)' do
    def returns_some_error check
      allow(check).to receive(:call).
        with(endpoint: endpoint, response: response).
        and_return([some_error])
    end

    def returns_no_error check
      allow(check).to receive(:call).
        with(endpoint: endpoint, response: response).
        and_return([])
    end

    before do
      returns_no_error Swaggable::CheckResponseContentType
    end

    it 'validates content type' do
      returns_some_error Swaggable::CheckResponseContentType
      expect(subject.errors_for_response(response)).to include(some_error)
    end

    it 'validates status code' do
      returns_some_error Swaggable::CheckResponseCode
      expect(subject.errors_for_response(response)).to include(some_error)
    end

    it 'validates response body'
  end
end

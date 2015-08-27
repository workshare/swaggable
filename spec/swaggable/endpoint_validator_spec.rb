require_relative '../spec_helper'
require 'rack'

RSpec.describe 'Swaggable::EndpointValidator' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new endpoint: endpoint_definition, request: request }
  let(:subject_class) { Swaggable::EndpointValidator }
  let(:request) { request_for :get, '/existing_endpoint' }
  let(:response) { [200, {}, []] }
  let(:endpoint_definition) { api_definition.endpoints.first }
  let(:request_content_type_validator) { Swaggable::RequestContentTypeValidator.new(content_types: []) }
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
    allow(Swaggable::RequestContentTypeValidator).
      to receive(:new).
      with(content_types: endpoint.consumes).
      and_return request_content_type_validator

    allow(Swaggable::CheckMandatoryParameters).
      to receive(:call).
      with(endpoint: endpoint, request: request).
      and_return([])


    allow(Swaggable::CheckExpectedParameters).
      to receive(:call).
      with(endpoint: endpoint, request: request).
      and_return([])

    allow(request_content_type_validator).
      to receive(:errors_for_request).
      with(request).
      and_return([])
  end

  describe '#errors_for_request(request)' do
    it 'is empty when all is correct' do
      expect(subject.errors_for_request(request)).to be_empty
    end

    it 'checks the content type against a RequestContentTypeValidator' do
      allow(request_content_type_validator).
        to receive(:errors_for_request).
        with(request).
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

    it 'validates all mandatory parameters are present' do
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
        with(body_definition: body, request: request).
        and_return([some_error])

      expect(subject.errors_for_request(request)).to include(some_error)
    end

    it 'validates all present parameters are supported'
  end

  describe '#errors_for_response(response)' do
    it 'validates response body'
    it 'validates content type'
    it 'validates status code'
  end
end

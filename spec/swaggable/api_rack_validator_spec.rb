require_relative '../spec_helper'
require 'rack'

RSpec.describe 'Swaggable::ApiRackValidator' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new definition: api_definition, request: api_request }
  let(:subject_class) { Swaggable::ApiRackValidator }
  let(:api_request) { request :get, '/existing_endpoint' }
  let(:api_response) { [200, {}, []] }

  let :api_definition do
    Swaggable::ApiDefinition.new do
      endpoints.add_new do
        path '/existing_endpoint'
        verb :get
      end
    end
  end

  def request verb, path
    Rack::MockRequest.env_for path, 'REQUEST_METHOD' => verb
  end

  describe '#endpoint_validator' do
    it 'has the right endpoint' do
      expect(subject.endpoint_validator.endpoint).to be subject.endpoint
    end

    it 'raises an exception if no endpoint was found' do
      api_definition.endpoints.first.path '/another_path'
      expect{ subject.endpoint_validator }.to raise_error(Swaggable::Errors::EndpointNotFound)
    end
  end

  describe '#errors_for_request()' do
    it 'delegates to the endpoint_validator' do
      errors = double('errors')

      allow(subject.endpoint_validator).
        to receive(:errors_for_request).
        with(api_request).
        and_return(errors)

      expect(subject.errors_for_request).to be errors
    end
  end

  describe '#errors_for_response(response)' do
    it 'delegates to the endpoint_validator' do
      errors = double('errors')

      allow(subject.endpoint_validator).
        to receive(:errors_for_response).
        with(api_response).
        and_return(errors)

      expect(subject.errors_for_response api_response).to be errors
    end
  end

  it 'supports api prefix'
end

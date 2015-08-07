require_relative '../spec_helper'

RSpec.describe 'Swaggable::EndpointRackValidator' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new endpoint: endpoint_definition, request: request }
  let(:subject_class) { Swaggable::EndpointRackValidator }
  let(:request) { request_for :get, '/existing_endpoint' }
  let(:response) { [200, {}, []] }
  let(:endpoint_definition) { api_definition.endpoints.first }

  let :api_definition do
    Swaggable::ApiDefinition.new do
      endpoints.add_new do
        path '/existing_endpoint'
        verb :get
      end
    end
  end

  def request_for verb, path
    Rack::MockRequest.env_for path, 'REQUEST_METHOD' => verb
  end

  describe '#errors_for_request(request)' do
    it 'is empty when all is correct' do
      expect(subject.errors_for_request(request)).to be_empty
    end

    it 'validates all mandatory parameters are present'
    it 'validates all present parameters are supported'
    it 'validates body schema'
    it 'validates content type'
  end

  describe '#errors_for_response(response)' do
    it 'validates response body'
    it 'validates content type'
    it 'validates status code'
  end
end

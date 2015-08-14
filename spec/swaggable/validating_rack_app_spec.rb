require_relative '../spec_helper'

RSpec.describe 'Swaggable::ValidatingRackApp' do
  let(:app) { Swaggable::ValidatingRackApp.new app: app_to_validate, definition: definition }
  let(:response) {  [200, {}, ['my-body']]  }
  let(:app_to_validate) { -> env { response } }
  let(:definition) { Swaggable::ApiDefinition.new }
  let(:request) { Rack::MockRequest.env_for '/', 'REQUEST_METHOD' => 'GET' }
  let(:validator) { Swaggable::ApiRackValidator.new }
  let(:some_errors) { Swaggable::Errors::ValidationsCollection.new }

  before do
    allow(Swaggable::ApiRackValidator).
      to receive(:new).
      and_return validator
  end

  def do_request
    app.call request
  end

  before do
    allow(validator).
      to receive(:errors_for_request).
      with(no_args).
      and_return([])

    allow(validator).
      to receive(:errors_for_response).
      with(response).
      and_return([])
  end

  context 'for valid request and response' do
    it 'raises no exception' do
      expect{ do_request }.not_to raise_error
    end

    it 'returns the response' do
      last_response = do_request
      expect(last_response).to be response
    end

    it 'wraps the request into a rack request adapter' do
      allow(Swaggable::ApiRackValidator).
        to receive(:new) {|args| expect(args[:request]).to be_a Swaggable::RackRequestAdapter }.
        and_return validator

      do_request
    end

    it 'wraps the response into a rack response adapter'
  end

  context 'for an invalid request' do
    before do
      allow(validator).
        to receive(:errors_for_request).
        with(no_args).
        and_return(some_errors)

      allow(some_errors).
        to receive(:any?).
        and_return true
    end

    it 'raises the request errors' do
      expect{ do_request }.to raise_error some_errors
    end

    it 'doesn\'t make the request' do
      expect(app_to_validate).not_to receive(:call)
      do_request rescue some_errors
    end
  end

  context 'for an invalid response' do
    before do
      allow(validator).
        to receive(:errors_for_response).
        with(response).
        and_return(some_errors)

      allow(some_errors).
        to receive(:any?).
        and_return true
    end

    it 'raises the response errors' do
      pending "of implementation of errors_for_response"
      expect{ do_request }.to raise_error some_errors
    end
  end
end

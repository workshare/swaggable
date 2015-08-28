require_relative '../spec_helper'
require 'rack'

RSpec.describe 'Swaggable::CheckExpectedParameters' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new }
  let(:subject_class) { Swaggable::CheckExpectedParameters }

  let(:parameters) { endpoint.parameters }
  let(:endpoint) { Swaggable::EndpointDefinition.new { path '/' } }
  let(:request) { Swaggable::RackRequestAdapter.new Rack::MockRequest.env_for("#{path}?#{query_string}") }
  let(:path) { '/' }
  let(:query_string) { '' }

  def do_run
    subject_class.call endpoint: endpoint, request: request
  end

  describe '.call' do
    context 'present parameter is expected' do
      it 'returns an empty errors list' do
        expect(do_run).to be_empty
      end
    end

    context 'present parameter is unexpected' do
      let(:query_string) { 'name=John' }

      it 'returns an empty errors list' do
        errors = do_run
        expect(errors.count).to eq 1
        expect(errors.first.message).to match /name/
      end
    end

  #   context 'all mandatory parameters are present' do
  #     before do
  #       parameters.add_new { name :email; required true }
  #       request.query_parameters[:email] = 'user@example.com'
  #     end

  #     it 'returns no errors' do
  #       expect(do_run).to be_empty
  #     end
  #   end

  #   context 'missing mandatory parameters undefined location' do
  #     before do
  #       parameters.add_new { name :email; required true }
  #     end

  #     it 'returns an error per missing parameter' do
  #       errors = do_run
  #       expect(errors.count).to eq 1
  #       expect(errors.first.message).to match /email/
  #     end
  #   end

  #   context 'missing mandatory query param' do
  #     before do
  #       parameters.add_new { name :email; required true; location :query }
  #     end

  #     it 'returns an error per missing parameter' do
  #       errors = do_run
  #       expect(errors.count).to eq 1
  #       expect(errors.first.message).to match /email/
  #     end
  #   end

  #   context 'missing mandatory path param' do
  #     before do
  #       parameters.add_new { name 'user_id'; required true; location :path }
  #     end

  #     it 'returns an error per missing parameter' do
  #       errors = do_run
  #       expect(errors.count).to eq 1
  #       expect(errors.first.message).to match /user_id/
  #     end
  #   end

  #   context 'present mandatory path param' do
  #     let(:path) { '/users/37.json' }

  #     before do
  #       endpoint.path '/users/{user_id}.json'
  #       parameters.add_new { name 'user_id'; required true; location :path }
  #     end

  #     it 'no errors' do
  #       expect(do_run).to be_empty
  #     end
  #   end

  #   context 'missing non-mandatory parameters' do
  #     before do
  #       parameters.add_new { name :email; required false }
  #     end

  #     it 'returns no errors' do
  #       expect(do_run).to be_empty
  #     end
  #   end

  #   # TODO
  #   describe 'header parameter'
  #   describe 'form parameter'
  end
end

require_relative '../spec_helper'
require 'rack'

RSpec.describe 'Swaggable::CheckMandatoryRackParameters' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new }
  let(:subject_class) { Swaggable::CheckMandatoryRackParameters }

  let(:parameters) { endpoint.parameters }
  let(:endpoint) { Swaggable::EndpointDefinition.new { path '/' } }

  let(:request) do
    Swaggable::RackRequestAdapter.new Rack::MockRequest.env_for(path, {
      'REQUEST_METHOD' =>  verb,
      'CONTENT_TYPE' => content_type,
      :input => body,
    })
  end

  let(:path) { '/' }
  let(:verb) { 'GET' }
  let(:content_type) { nil }
  let(:body) { nil }

  def do_run
    subject_class.call endpoint: endpoint, request: request
  end

  describe '.call' do
    context 'no mandatory parameters' do
      it 'returns an empty errors list' do
        expect(do_run).to be_empty
      end
    end

    context 'all mandatory parameters are present' do
      before do
        parameters.add_new { name :email; required true }
        request.query_parameters[:email] = 'user@example.com'
      end

      it 'returns no errors' do
        expect(do_run).to be_empty
      end
    end

    context 'missing mandatory parameters undefined location' do
      before do
        parameters.add_new { name :email; required true }
      end

      it 'returns an error per missing parameter' do
        errors = do_run
        expect(errors.count).to eq 1
        expect(errors.first.message).to match /email/
      end
    end

    context 'missing mandatory query param' do
      before do
        parameters.add_new { name :email; required true; location :query }
      end

      it 'returns an error per missing parameter' do
        errors = do_run
        expect(errors.count).to eq 1
        expect(errors.first.message).to match /email/
      end
    end

    context 'missing mandatory path param' do
      before do
        parameters.add_new { name 'user_id'; required true; location :path }
      end

      it 'returns an error per missing parameter' do
        errors = do_run
        expect(errors.count).to eq 1
        expect(errors.first.message).to match /user_id/
      end
    end

    context 'present mandatory path param' do
      let(:path) { '/users/37.json' }

      before do
        endpoint.path '/users/{user_id}.json'
        parameters.add_new { name 'user_id'; required true; location :path }
      end

      it 'no errors' do
        expect(do_run).to be_empty
      end
    end

    context 'missing non-mandatory parameters' do
      before do
        parameters.add_new { name :email; required false }
      end

      it 'returns no errors' do
        expect(do_run).to be_empty
      end
    end

    describe 'body parameter' do
      context 'present and there is no schema' do
        let(:verb) { 'POST' }
        let(:body) { '{}' }

        before do
          parameters.add_new { name :user; required true; location :body }
        end

        it 'returns no error' do
          expect(do_run).to be_empty
        end
      end

      context 'present and matches schema' do
        let(:verb) { 'POST' }
        let(:content_type) { 'application/json' }
        let(:body) { '{"name":"John"}' }

        before do
          parameters.add_new do
            name :user
            required true
            location :body

            schema do
              attributes do
                add_new do
                  name :name
                  type :string
                end
              end
            end
          end
        end

        it 'returns no error' do
          expect(do_run).to be_empty
        end
      end

      context 'when required but not present' do
        let(:verb) { 'POST' }

        before do
          parameters.add_new do
            name :user
            required true
            location :body
          end
        end

        it 'returns error' do
          errors = do_run
          expect(errors.count).to eq 1
          expect(errors.first.message).to match /body/
        end
      end

      context 'when present but wrong schema' do
        let(:verb) { 'POST' }
        let(:content_type) { 'application/json' }
        let(:body) { '{}' }

        before do
          parameters.add_new do
            name :user
            required true
            location :body

            schema do
              attributes do
                add_new do
                  name :name
                  type :string
                  required true
                end
              end
            end
          end
        end

        it 'returns error' do
          errors = do_run
          expect(errors.count).to eq 1
          expect(errors.first.message).to match /body/
        end
      end
    end

    # TODO
    describe 'header parameter'
    describe 'form parameter'
  end
end

require_relative '../spec_helper'
require 'rack'

RSpec.describe 'Swaggable::CheckMandatoryRackParameters' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new }
  let(:subject_class) { Swaggable::CheckMandatoryRackParameters }

  let(:parameters) { Swaggable::EndpointDefinition.new.parameters }
  let(:request) { Swaggable::RackRequestAdapter.new Rack::MockRequest.env_for('/') }

  def do_run
    subject_class.call parameters: parameters, request: request
  end

  describe '.call' do
    context 'no mandatory params' do
      it 'returns an empty errors list' do
        expect(do_run).to be_empty
      end
    end

    context 'all mandatory params are present' do
      before do
        parameters.add_new do
          name :email
          required true
        end

        request.query_params[:email] = 'user@example.com'
      end

      it 'returns no errors' do
        expect(do_run).to be_empty
      end
    end

    context 'missing mandatory params' do
      before do
        parameters.add_new do
          name :email
          required true
        end
      end

      it 'returns an error per missing parameter' do
        errors = do_run
        expect(errors.count).to eq 1
        expect(errors.first.message).to match /email/
      end
    end

    context 'missing mandatory query param' do
      before do
        parameters.add_new do
          name :email
          required true
          location :query
        end
      end

      it 'returns an error per missing parameter' do
        errors = do_run
        expect(errors.count).to eq 1
        expect(errors.first.message).to match /email/
      end
    end

    context 'missing non-mandatory params' do
      before do
        parameters.add_new do
          name :email
          required false
        end
      end

      it 'returns an error per missing parameter' do
        expect(do_run).to be_empty
      end
    end

    it 'supports :location, [:path, :query, :header, :body, :form, nil]'
  end
end

require_relative '../spec_helper'

RSpec.describe 'Swaggable::CheckResponseContentType' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new endpoint: endpoint, response: response }
  let(:subject_class) { Swaggable::CheckResponseContentType }

  let(:content_types) { endpoint.produces }
  let(:endpoint) { Swaggable::EndpointDefinition.new }
  let(:response) { Swaggable::RackResponseAdapter.new }

  describe '.call' do
    def do_run
      subject_class.call endpoint: endpoint, response: response
    end

    context 'no response content_type' do
      it 'returns an empty errors collection' do
        expect(do_run).to be_empty
      end
    end

    context 'unsupported reponse content_type' do
      before { response.content_type = 'application/json' }
      before { content_types << :xml }

      it 'returns errors collection' do
        errors = do_run

        expect(errors.count).to eq 1
        expect(errors.first).to be_a Swaggable::Errors::Validation
      end
    end

    context 'supported response content_type' do
      before { content_types << :json }

      it 'returns empty errors collection' do
        errors = do_run
        expect(errors.count).to eq 0
      end

      it 'still works with charset=utf-8' do
        response.content_type = 'application/json; charset=utf-8'

        errors = do_run
        expect(errors.count).to eq 0
      end
    end
  end
end

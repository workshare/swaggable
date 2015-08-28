require_relative '../spec_helper'

RSpec.describe 'Swaggable::CheckResponseCode' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new endpoint: endpoint, response: response }
  let(:subject_class) { Swaggable::CheckResponseCode }

  let(:endpoint) { Swaggable::EndpointDefinition.new }
  let(:response) { Swaggable::RackResponseAdapter.new }

  describe '.call' do
    def do_run
      subject_class.call endpoint: endpoint, response: response
    end

    context 'supported status code' do
      it 'returns an empty errors collection' do
        endpoint.responses.add_new{ status 200 }
        response.code = 200

        expect(do_run).to be_empty
      end
    end

    context 'non supported status code' do
      it 'returns an empty errors collection' do
        endpoint.responses.add_new{ status 200 }
        response.code = 418
        errors = do_run

        expect(errors.count).to eq 1
        expect(errors.first).to be_a Swaggable::Errors::Validation
        expect(errors.message).to match /code/
      end
    end
  end
end

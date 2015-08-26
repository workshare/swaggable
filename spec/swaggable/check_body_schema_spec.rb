require_relative '../spec_helper'
require 'rack'

RSpec.describe 'Swaggable::CheckBodySchema' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new }
  let(:subject_class) { Swaggable::CheckBodySchema }


  let(:request) do
    Swaggable::RackRequestAdapter.new Rack::MockRequest.env_for('/', {
      'REQUEST_METHOD' =>  'POST',
      'CONTENT_TYPE' => content_type,
      :input => body,
    })
  end

  let(:verb) { 'POST' }
  let(:content_type) { nil }
  let(:body) { nil }

  let(:body_definition) { Swaggable::ParameterDefinition.new { location :body } }

  def do_run
    subject_class.call body_definition: body_definition, request: request
  end

  describe '.call' do
    context 'present and there is no schema' do
      let(:body) { '{}' }
      before { body_definition.required true }

      it 'returns no error' do
        expect(do_run).to be_empty
      end
    end

    context 'present and matches schema' do
      let(:content_type) { 'application/json' }
      let(:body) { '{"name":"John"}' }

      before do
        body_definition.schema.attributes.add_new { name 'name'; type :string }
      end

      it 'returns no error' do
        expect(do_run).to be_empty
      end
    end

    context 'when required but not present' do
      before { body_definition.required true }

      it 'returns error' do
        errors = do_run
        expect(errors.count).to eq 1
        expect(errors.first.message).to match /body/
      end
    end

    context 'when present but missing required attribute' do
      let(:content_type) { 'application/json' }
      let(:body) { '{}' }

      before do
        body_definition.required true
        body_definition.schema.attributes.add_new { name 'name'; type :string; required true }
      end

      it 'returns error' do
        errors = do_run
        expect(errors.count).to eq 1
        expect(errors.first.message).to match /body/
      end
    end

    context 'when present but missing unexpected attribute' do
      let(:content_type) { 'application/json' }
      let(:body) { '{"made_up_attribute":42}' }

      before do
        body_definition.required true
        body_definition.schema.attributes.add_new { name 'name'; type :string }
      end

      it 'returns error' do
        errors = do_run
        expect(errors.count).to eq 1
        expect(errors.first.message).to match /body/
      end
    end
  end
end

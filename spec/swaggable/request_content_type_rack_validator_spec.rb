require_relative '../spec_helper'

RSpec.describe 'Swaggable::RequestContentTypeRackValidator' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new content_types: content_types }
  let(:subject_class) { Swaggable::RequestContentTypeRackValidator }
  let(:content_types) { Swaggable::MimeTypesCollection.new }

  describe '#errors_for_request' do
    context 'no request content_type' do
      let(:request) { {} }

      it 'returns an empty errors collection' do
        expect(subject.errors_for_request request).to be_empty
      end
    end

    context 'unsupported request content_type' do
      let(:request) { {'CONTENT_TYPE' => 'application/xml'} }

      it 'returns errors collection' do
        errors = subject.errors_for_request request

        expect(errors.count).to eq 1
        expect(errors.first).to be_a Swaggable::Errors::Validation
      end
    end

    context 'supported request content_type' do
      let(:request) { {'CONTENT_TYPE' => 'application/json'} }
      before { content_types << :json }

      it 'returns empty errors collection' do
        errors = subject.errors_for_request request
        expect(errors.count).to eq 0
      end

      it 'still works with charset=utf-8' do
        request['CONTENT_TYPE'] += '; charset=utf-8'

        errors = subject.errors_for_request request
        expect(errors.count).to eq 0
      end
    end
  end
end

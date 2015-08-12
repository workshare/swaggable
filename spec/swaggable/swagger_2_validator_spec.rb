require_relative '../spec_helper'
require 'json'
require 'json-schema'

RSpec.describe 'Swaggable::Swagger2Validator' do
  describe '.validate!' do
    subject { Swaggable::Swagger2Validator }

    let(:valid_swagger) { JSON.parse File.read('spec/assets/valid-swagger-2.0.json') }
    let(:invalid_swagger) { valid_swagger.merge!("info" => nil) }

    it 'returns true for a valid schema' do
      expect(subject.validate! valid_swagger).to be true
    end

    it 'raises exception true for an invalid schema' do
      expect{ subject.validate! invalid_swagger }.
        to raise_error(JSON::Schema::ValidationError)#(Swaggable::Swagger2Validator::ValidationError)
    end

    it 'has a meaningful exception message' do
      exception = subject.validate!(invalid_swagger) rescue $!
      expect(exception.message).to match(/info/)
    end
  end

  describe '.validate' do
    subject { Swaggable::Swagger2Validator }

    let(:valid_swagger) { JSON.parse File.read('spec/assets/valid-swagger-2.0.json') }
    let(:invalid_swagger) { valid_swagger.merge!("info" => nil) }

    it 'returns empty errors for a valid schema' do
      expect(subject.validate valid_swagger).to be_blank
    end

    it 'returns errors for invalid schema' do
      expect(subject.validate invalid_swagger).not_to be_blank
    end
  end
end

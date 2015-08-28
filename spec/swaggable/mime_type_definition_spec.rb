require_relative '../spec_helper'

RSpec.describe 'Swaggable::MimeTypeDefinition' do
  let(:subject_class) { Swaggable::MimeTypeDefinition }
  let(:subject_instance) { subject_class.new :json }
  subject { subject_instance }

  describe '.new' do
    it 'accepts a symbol with the subtype' do
      expect(subject.name).to eq('application/json')
    end

    it 'accepts a symbol with the subtype with underescores' do
      subject = subject_class.new :octet_stream
      expect(subject.name).to eq('application/octet-stream')
    end

    it 'accepts a name' do
      expect(subject.name).to eq('application/json')
    end

    it 'accepts options' do
      subject = subject_class.new 'application/json; charset=utf-8'
      expect(subject.name).to eq('application/json')
    end
  end

  describe '#name' do
    it 'is type/subtype' do
      expect(subject.name).to eq('application/json')
    end
  end

  describe '#to_s' do
    it 'is the name' do
      expect(subject.to_s).to eq(subject.name)
    end
  end

  describe '#http_string' do
    it 'is "type/subtype; parameters"' do
      expect(subject.http_string).to match(/^application\/json.*$/)
    end

    it 'contains options' do
      subject = subject_class.new 'application/json; charset=utf-8'
      expect(subject.http_string).to eq('application/json; charset=utf-8')
    end
  end

  describe '#to_sym' do
    describe 'when type is application' do
      it 'is the subtype with underescores' do
        subject = subject_class.new 'application/octet-stream'
        expect(subject.to_sym).to eq(:octet_stream)
      end
    end

    describe 'when type is NOT application' do
      it 'is the name with underescores' do
        subject = subject_class.new 'random/sub-type.with.dots'
        expect(subject.to_sym).to eq(:random_sub_type_with_dots)
      end
    end
  end

  describe '#inspect' do
    it 'is #<Swaggable::ContentTypeDefinition: type/subtype>' do
      expect(subject.inspect).to eq('#<Swaggable::ContentTypeDefinition: application/json>')
    end
  end

  describe '#==' do
    it 'equals by name' do
      type_1 = subject_class.new :json
      type_1_again = subject_class.new :json
      type_2 = subject_class.new :xml

      expect(type_1).to eq type_1_again
      expect([type_1, type_1_again].uniq.length).to eq 1
      expect(type_1).not_to eq type_2
    end

    it 'equals by symbol' do
      expect(subject == :json).to be true
    end

    it 'equals string' do
      expect(subject == 'application/json').to be true
    end

    it 'doesn\'t throw error if comparing with any random object' do
      expect{ subject == double }.not_to raise_error
    end
  end
end

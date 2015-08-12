require_relative '../spec_helper'

RSpec.describe 'Swaggable::MimeTypesCollection' do
  let(:subject_class) { Swaggable::MimeTypesCollection }
  let(:subject_instance) { subject_class.new }
  subject { subject_instance }

  describe '#<<' do
    it 'adds MimeTypeDefinitions as is' do
      type = Swaggable::MimeTypeDefinition.new(:json)
      subject << type
      expect(subject.last).to be type
    end

    it 'overrides duplicates' do
      type_1 = Swaggable::MimeTypeDefinition.new(:json)
      type_2 = Swaggable::MimeTypeDefinition.new(:json)
      subject << type_1
      subject << type_2
      expect(subject.count).to eq 1
      expect(subject.last).to be type_2
    end

    it 'converts symbols into mime MimeTypeDefinitions' do
      subject << :json
      expect(subject.first).to eq Swaggable::MimeTypeDefinition.new(:json)
    end

    it 'converts strings into mime MimeTypeDefinitions' do
      subject << 'application/json'
      expect(subject.first).to eq Swaggable::MimeTypeDefinition.new(:json)
    end
  end

  describe '#each' do
    it 'iterates through the list' do
      subject << :json
      list = []

      subject.each {|e| list << e.name }

      expect(list).to eq(['application/json'])
    end
  end

  describe '#include?' do
    it 'returns true if present' do
      entry = Swaggable::MimeTypeDefinition.new(:json)
      subject << entry
      expect(subject).to include(entry)
    end
  end

  describe '#[]' do
    it 'returns entries by symbol' do
      entry = Swaggable::MimeTypeDefinition.new(:json)
      subject << entry
      expect(subject[:json]).to be entry
    end

    it 'returns entries by string' do
      entry = Swaggable::MimeTypeDefinition.new(:json)
      subject << entry
      expect(subject['application/json']).to be entry
    end
  end

  describe '#inspect' do
    it 'is readable' do
      subject << :json
      subject << :xml
      expect(subject.inspect).to eq "#<Swaggable::MimeTypesCollection: application/json, application/xml>"
    end
  end

  describe '#==' do
    it 'matches if the entries match' do
      subject << :json

      expect(subject).to eq [:json]
    end
  end

  describe '#merge' do
    it 'joins the lists' do
      subject << :json

      other = subject_class.new
      other << :xml

      subject.merge(other)

      expect(subject).to eq [:json, :xml]
    end

    it 'joins lists of symbols' do
      subject << :json
      subject.merge([:xml])
      expect(subject).to eq [:json, :xml]
    end
  end
end

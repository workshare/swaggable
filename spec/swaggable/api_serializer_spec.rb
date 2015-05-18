require_relative '../spec_helper'

RSpec.describe 'Swaggable::Swagger2Serializer' do
  let(:subject_class) { Swaggable::Swagger2Serializer }
  let(:subject_instance) { Swaggable::Swagger2Serializer.new }
  subject { subject_instance }

  let(:api) { Swaggable::ApiDefinition.new }

  describe '#serialize' do
    def output
      subject.serialize(api)
    end

    it 'has swagger version 2.0' do
      expect(output[:swagger]).to eq '2.0'
    end

    it 'has basePath' do
      api.base_path = '/a/path'
      expect(output[:basePath]).to eq '/a/path'
    end

    it 'has title' do
      api.title = 'A Title'
      expect(output[:info][:title]).to eq 'A Title'
    end

    it 'has description' do
      api.description = 'A Desc'
      expect(output[:info][:description]).to eq 'A Desc'
    end

    it 'has version' do
      api.version = 'v1.0'
      expect(output[:info][:version]).to eq 'v1.0'
    end
  end
end

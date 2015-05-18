require_relative '../spec_helper'
require 'grape'

RSpec.describe 'Swaggable::GrapeAdapter' do
  let(:subject_class) { Swaggable::GrapeAdapter }
  let(:subject_instance) { Swaggable::GrapeAdapter.new }
  subject { subject_instance }

  describe '#import(grape_api, api_definition)' do
    let(:api) { Swaggable::ApiDefinition.new }
    let(:grape) { Class.new(Grape::API) }

    def do_import
      subject.import grape, api
    end

    it 'sets version' do
      grape.version 'v2.0'
      do_import
      expect(api.version).to eq 'v2.0'
    end

    it 'sets title' do
      allow(grape).to receive(:name).and_return('MyAPI')
      do_import
      expect(api.title).to eq 'MyAPI'
    end

    it 'sets base path' do
      do_import
      expect(api.base_path).to eq '/'
    end

    describe 'endpoints' do
      it 'sets verb' do
        grape.post { }
        do_import
        expect(api.endpoints.first.verb).to eq 'POST'
      end

      it 'sets description' do
        grape.desc 'My endpoint'
        grape.post { }
        do_import
        expect(api.endpoints.first.description).to eq 'My endpoint'
      end

      it 'sets format' do
        grape.format :json
        grape.post { }
        do_import
        expect(api.endpoints.first.produces).to eq ['application/json']
      end

      describe 'path' do
        it 'has no (.:format)' do
          grape.post('/a/path') { }
          do_import
          expect(api.endpoints.first.path).to eq '/a/path'
        end

        it 'has subtitutes the version' do
          grape.version 'v3.0'
          # grape.prefix '/api'
          grape.post('/a/path') { }
          do_import
          expect(api.endpoints.first.path).to eq '/v3.0/a/path'
        end
      end
    end
  end
end

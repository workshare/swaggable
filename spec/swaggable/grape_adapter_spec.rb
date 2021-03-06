require_relative '../spec_helper'
require 'grape'
require 'grape-entity'

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

    it 'returns the api' do
      api = do_import
      expect(api).to be_a Swaggable::ApiDefinition
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

      it 'sets description as summary' do
        grape.desc 'My endpoint'
        grape.post { }
        do_import
        expect(api.endpoints.first.summary).to eq 'My endpoint'
      end

      it 'sets produces' do
        grape.format :json
        grape.content_type :xml, 'application/xml'
        grape.post { }
        do_import
        expect(api.endpoints.first.produces.to_a).to eq ['application/json', 'application/xml']
      end

      it 'sets consumes' do
        grape.format :json
        grape.content_type :xml, 'application/xml'
        grape.post { }
        do_import
        expect(api.endpoints.first.consumes.to_a).to eq ['application/json', 'application/xml']
      end

      describe 'path' do
        it 'has no (.:format)' do
          grape.post('/a/path') { }
          do_import
          expect(api.endpoints.first.path).to eq '/a/path'
        end

        it 'has no (/.:format)' do
          grape.version 'v1.0'
          grape.get('/') { }
          do_import
          expect(api.endpoints.first.path).to eq '/v1.0'
        end

        it 'has version number' do
          grape.version 'v3.0'
          grape.post('/a/path') { }
          do_import
          expect(api.endpoints.first.path).to eq '/v3.0/a/path'
        end

        it 'has version number if present with prefix too' do
          grape.version 'v3.0'
          grape.prefix '/api'
          grape.post('/a/path') { }
          do_import
          expect(api.endpoints.first.path).to eq '/api/v3.0/a/path'
        end

        it 'has version number if present with prefix not beginning with / too' do
          grape.version 'v3.0'
          grape.prefix 'api'
          grape.post('/a/path') { }
          do_import
          expect(api.endpoints.first.path).to eq '/api/v3.0/a/path'
        end

        it 'has parameters' do
          grape.version 'v3.0'
          grape.prefix '/api'
          grape.post('/a/path/:with/:parameters') { }
          do_import
          expect(api.endpoints.first.path).to eq '/api/v3.0/a/path/{with}/{parameters}'
        end

        it 'has tags' do
          grape.post('/a/path') { }
          do_import
          tag = api.endpoints.first.tags.first
          expect(tag.name).to eq grape.name
        end
      end

      describe 'parameters' do
        it 'have name' do
          grape.params do
            requires :user_uuid
          end

          grape.post('/a/path') { }

          do_import
          expect(api.endpoints.first.parameters.first.name).to eq 'user_uuid'
        end

        it 'have type' do
          grape.params do
            requires :user_uuid, type: String
          end

          grape.post('/a/path') { }

          do_import
          expect(api.endpoints.first.parameters.first.type).to eq :string
        end

        it 'have required' do
          grape.params do
            requires :required_param
          end

          grape.post('/a/path') { }

          do_import
          expect(api.endpoints.first.parameters.first.required).to eq true
        end

        it 'have description' do
          grape.params do
            requires :param, desc: 'A param'
          end

          grape.post('/a/path') { }

          do_import
          expect(api.endpoints.first.parameters.first.description).to eq 'A param'
        end

        it 'have location path if path param' do
          grape.params do
            requires :required_param
          end

          grape.post('/a/:required_param') { }

          do_import
          expect(api.endpoints.first.parameters.first.location).to eq :path
        end

        it 'have location query if non-path param' do
          grape.params do
            requires :required_param
          end

          grape.post('/a') { }

          do_import
          expect(api.endpoints.first.parameters.first.location).to eq :query
        end
      end

      describe 'responses' do
        it 'have status' do
          grape.post('/', http_codes: [201, 'Created']) { }

          do_import
          expect(api.endpoints.first.responses.first.status).to eq 201
        end

        it 'have description' do
          grape.post('/', http_codes: [[201, 'Created']]) { }

          do_import
          expect(api.endpoints.first.responses.first.description).to eq 'Created'
        end
      end

      describe 'entities' do
        it 'generates an schema' do
          user_class = Class.new(Grape::Entity)

          grape.desc 'Create User', entity: user_class
          grape.post('/')

          parameter_definition = Swaggable::ParameterDefinition.new name: :first_name

          allow(Swaggable::GrapeEntityTranslator).
            to receive(:parameter_from).
            with(user_class).
            and_return(parameter_definition)

          do_import

          parameter = api.endpoints['POST /'].parameters['first_name']
          expect(parameter).to be parameter_definition
        end
      end
    end
  end
end

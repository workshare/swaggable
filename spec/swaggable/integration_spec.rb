require_relative '../spec_helper'
require 'rack/test'
require 'grape'

RSpec.describe 'Integration' do
  context 'RackApp' do
    include Rack::Test::Methods

    def app
      subject
    end

    subject { rack_app }
    let(:rack_app) { Swaggable::RackApp.new(api_definition: api_def) }
    let(:api_def) { Swaggable::ApiDefinition.from_grape_api(grape_api) }

    let(:grape_api) do
      Class.new(Grape::API).tap do |g|
        g.params do
          requires :user_uuid
        end

        g.get '/' do
          status 200
          body({some: 'body'})
        end

      end.tap do |grape|
        stub_const('MyGrapeApi', grape)
      end
    end

    it 'has status 200 OK' do
      get '/'
      expect(last_response.status).to eq 200
      expect(last_response.headers['Content-Type']).to eq 'application/json'
    end

    it 'validates' do
      expect(subject.validate!).to be true
    end
  end

  context 'dsl' do
    it 'supports a full description of the API' do
      api = Swaggable::ApiDefinition.new do
        version '1.0'
        title 'My API'
        description 'A test API'
        base_path '/api/1.0'

        endpoints.add_new do
          path '/users/{id}'
          verb :get
          description 'Shows an user'
          summary 'Returns the JSON representation of such user'

          tags.add_new do
            name 'Users'
            description 'Users resource'
          end

          parameters.add_new do
            name 'include_comments_count'
            description 'It will return the comments_count attribute when set to true'
            location :query # [:path, :query, :header, :body, :form, nil]
            required false
            type :boolean # [:string, :number, :integer, :boolean, :array, :file, nil]
          end

          responses.add_new do
            status 200
            description 'Success'
          end

          responses.add_new do
            status 404
            description 'User not found'
          end

          consumes << :json
          produces << :json
        end
      end

      expect(api.version).to eq '1.0'
      expect(api.endpoints.first).to be api.endpoints['GET /users/{id}']
      expect(api.endpoints.first.path).to eq '/users/{id}'
      expect(api.endpoints.first.tags.first).to be api.endpoints.first.tags['Users']
      expect(api.endpoints.first.tags.first.name).to eq 'Users'
      expect(api.endpoints.first.parameters.first).to be api.endpoints.first.parameters['include_comments_count']
      expect(api.endpoints.first.parameters.first.name).to eq 'include_comments_count'
      expect(api.endpoints.first.responses.first).to be api.endpoints.first.responses[200]
      expect(api.endpoints.first.responses.first.description).to eq 'Success'
      expect(api.endpoints.first.consumes).to eq [:json]
      expect(api.endpoints.first.produces).to eq [:json]
    end
  end
end


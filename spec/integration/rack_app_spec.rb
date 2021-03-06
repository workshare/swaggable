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
end


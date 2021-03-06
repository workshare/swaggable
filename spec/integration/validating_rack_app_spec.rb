require_relative '../spec_helper'
require 'rack/test'
require 'grape'

RSpec.describe 'Integration' do
  describe 'ValidatorRackApp' do
    include Rack::Test::Methods

    def app_to_validate
      @app_to_validate ||= -> env { [200, {}, []] }
    end

    def app
      Swaggable::ValidatingRackApp.new app: app_to_validate, definition: definition
    end

    let :definition do
      Swaggable::ApiDefinition.new do
        endpoints.add_new do
          path '/existing_endpoint'
          verb :get

          responses.add_new do
            status 200
            description 'Success'
          end

          consumes << :json
          produces << :json
        end
      end
    end

    it 'does nothing if the validations pass' do
      expect{ get '/existing_endpoint', {}, 'CONTENT_TYPE' => 'application/json' }.
        not_to raise_error
    end

    it 'raises an exception if request validation doesn\'t pass' do
      expect{ get '/existing_endpoint', {}, 'CONTENT_TYPE' => 'application/xml' }.
        to raise_error Swaggable::Errors::Validation
    end

    it 'raises an exception if response validation doesn\'t pass' do
      @app_to_validate = -> env { [418, {'Content-Type' => 'application/xml'}, ['']] }
      expect{ get '/existing_endpoint' }.to raise_error Swaggable::Errors::Validation
    end
  end
end


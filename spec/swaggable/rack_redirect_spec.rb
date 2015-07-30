require_relative '../spec_helper'
require 'rack/test'

RSpec.describe 'Swaggable::RackRedirect' do
  include Rack::Test::Methods

  let(:subject_class) { Swaggable::RackRedirect }
  let(:subject_instance) { Swaggable::RackRedirect.new }
  subject { subject_instance }

  let(:next_app) { double('next_app', call: [200, {}, []]) }

  it 'fails if not expected options are given' do
    expect { Swaggable::RackRedirect.new to: '/', unexpected: nil }.to raise_error ArgumentError
  end

  describe 'within map' do
    def app
      @app ||= Rack::Builder.new do
        map('/origin') { run Swaggable::RackRedirect.new to: '/destination' }
      end
    end

    it 'redirects /origin to /destination' do
      get '/origin'
      expect(last_response.status).to eq 301
      expect(last_response.headers['Location']).to eq '/destination'
    end
  end

  describe 'with use' do
    describe 'with /origin as a string' do
      def app
        @app ||= Rack::Builder.new.tap do |r|
          r.use Swaggable::RackRedirect, from: '/origin', to: '/destination'
          r.run next_app
        end
      end

      it 'redirects /origin to /destination' do
        get '/origin'
        expect(last_response.status).to eq 301
        expect(last_response.headers['Location']).to eq '/destination'
      end

      it 'forwards the request to the next app if path is not /origin' do
        expect(next_app).to receive :call
        get '/other'
      end

      it 'forwards the request to the next app if path is /origin/something_else' do
        expect(next_app).to receive :call
        get '/origin/something_else'
      end
    end

    describe 'with /origin as a regex' do
      def app
        @app ||= Rack::Builder.new.tap do |r|
          r.use Swaggable::RackRedirect, from: /origin/, to: '/destination'
          r.run next_app
        end
      end

      it 'redirects /origin to /destination if the regex matches' do
        get '/match_origin'
        expect(last_response.status).to eq 301
        expect(last_response.headers['Location']).to eq '/destination'
      end

      it 'forwards the request to the next app if the regex doesn\'t match' do
        expect(next_app).to receive :call
        get '/no_match'
      end
    end
  end
end

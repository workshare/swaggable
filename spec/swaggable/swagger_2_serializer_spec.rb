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

    it 'has title empty string if nil' do
      api.title = nil
      expect(output[:info][:title]).to eq ''
    end

    it 'has description' do
      api.description = 'A Desc'
      expect(output[:info][:description]).to eq 'A Desc'
    end

    it 'has no description if nil' do
      api.description = nil
      expect(output[:info].has_key?(:description)).to be false
    end

    it 'has version' do
      api.version = 'v1.0'
      expect(output[:info][:version]).to eq 'v1.0'
    end

    it 'has version "0.0.0" if nil' do
      api.version = nil
      expect(output[:info][:version]).to eq "0.0.0"
    end

    describe '#tags' do
      def serialized_tag
        output[:tags].first
      end

      let(:api) { Swaggable::ApiDefinition.new {|a| a.endpoints << endpoint } }
      let(:endpoint) { Swaggable::EndpointDefinition.new {|e| e.tags << tag } }
      let(:tag) { Swaggable::TagDefinition.new name: 'A Tag', description: 'A tag description' } 

      it 'has a name' do
        expect(serialized_tag[:name]).to eq tag.name
      end

      it 'has a description' do
        expect(serialized_tag[:description]).to eq tag.description
      end

      it 'has no description if nil' do
        tag.description = nil
        expect(serialized_tag.has_key?(:description)).to be false
      end
    end

    describe '#endpoints' do
      let(:api) { Swaggable::ApiDefinition.new {|a| a.endpoints << endpoint } }
      let(:endpoint) { Swaggable::EndpointDefinition.new path: path, verb: verb }
      let(:path) { '/a/path' }
      let(:verb) { 'POST' }

      it 'uses the path as key' do
        expect(output[:paths][path]).not_to be_nil
      end

      it 'uses the verb as key' do
        expect(output[:paths][path][verb]).not_to be_nil
      end

      def serialized_endpoint
        output[:paths][path][verb]
      end

      it 'has description' do
        endpoint.description = 'A desc.'
        expect(serialized_endpoint[:description]).to eq 'A desc.'
      end

      it 'has no description if nil' do
        endpoint.description = nil
        expect(serialized_endpoint.has_key?(:description)).to be false
      end

      it 'has summary' do
        endpoint.summary = 'A summary.'
        expect(serialized_endpoint[:summary]).to eq 'A summary.'
      end

      it 'has no summary if summary is nil' do
        endpoint.summary = nil
        expect(serialized_endpoint.has_key?(:summary)).to be false
      end

      it 'has tags' do
        endpoint.tags << Swaggable::TagDefinition.new(name: 'Tag 1')
        endpoint.tags << Swaggable::TagDefinition.new(name: 'Tag 2')
        expect(serialized_endpoint[:tags]).to eq ['Tag 1', 'Tag 2']
      end

      it 'has consumes' do
        endpoint.consumes << 'application/whatever'
        expect(serialized_endpoint[:consumes]).to eq ['application/whatever']
      end

      it 'has produces' do
        endpoint.produces << 'application/whatever'
        expect(serialized_endpoint[:produces]).to eq ['application/whatever']
      end

      it 'works with two endpoints with the same path' do
        api.endpoints << Swaggable::EndpointDefinition.new(path: path, verb: 'get')

        expect(output[:paths][path][verb]).not_to be_nil
        expect(output[:paths][path]['get']).not_to be_nil
      end

      describe 'responses' do
        it 'defaults to 200  Success' do
          expect(serialized_endpoint[:responses]).to eq({200 => {description: "Success"}})
        end

        it 'is taken from the responses' do
          endpoint.responses.add_new do
            status 418
            description 'Teapot'
          end

          expect(serialized_endpoint[:responses]).to eq({418 => {description: "Teapot"}})
        end
      end

      describe 'parameters' do
        before(:each) { endpoint.parameters << parameter }
        let(:parameter) { Swaggable::ParameterDefinition.new location: :query }

        def serialized_parameter
          serialized_endpoint[:parameters].first
        end

        it 'has "in"' do
          expect(serialized_parameter[:in]).to eq 'query'
        end

        it 'has name' do
          parameter.name = 'my_param'
          expect(serialized_parameter[:name]).to eq 'my_param'
        end

        it 'has description' do
          parameter.description = 'A param'
          expect(serialized_parameter[:description]).to eq 'A param'
        end

        it 'has no description if nil' do
          parameter.description = nil
          expect(serialized_parameter.has_key?(:description)).to be false
        end

        it 'has required' do
          parameter.required = nil
          expect(serialized_parameter[:required]).to eq false
        end

        it 'has type if present' do
          parameter.type = :string
          expect(serialized_parameter[:type]).to eq :string
        end

        it 'has type string if nil' do
          parameter.type = nil
          expect(serialized_parameter[:type]).to eq 'string'
        end
      end
    end
  end

  describe '#validate!' do
    it 'validates against Swagger2Validator' do
      expect(Swaggable::Swagger2Validator).
        to receive(:validate!).
        with(subject.serialize api).
        and_return(true)

      subject.validate! api
    end
  end
end

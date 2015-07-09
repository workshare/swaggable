require_relative '../spec_helper'
require 'grape'
require 'grape-entity'

RSpec.describe 'Swaggable::GrapeEntityTranslator' do
  subject { Swaggable::GrapeEntityTranslator }

  describe '.parameter_from' do
    let(:generated_parameter) { subject.parameter_from entity }

    let(:entity) do
      Class.new(Grape::Entity) do
        def self.name
          'UserEntity'
        end
      end
    end

    it 'returns a parameter' do
      expect(generated_parameter).to be_a Swaggable::ParameterDefinition
    end

    it 'is body param' do
      expect(generated_parameter.location).to be :body
    end

    it 'gives it a name' do
      expect(generated_parameter.name).to eq 'UserEntity'
    end

    it 'gives a name to the schema too' do
      expect(generated_parameter.schema.name).to eq 'UserEntity'
    end

    describe 'schema attributes' do
      let(:generated_attr) { generated_parameter.schema.attributes.first }

      it 'sets the name' do
        entity.expose :first_name
        expect(generated_attr.name).to be :first_name
      end

      it 'sets the type' do
        entity.expose :first_name, documentation: {type: 'String'}
        expect(generated_attr.type).to be :string
      end

      it 'sets the description' do
        entity.expose :first_name, documentation: {desc: 'First Name'}
        expect(generated_attr.description).to eq 'First Name'
      end

      it 'sets the required field' do
        entity.expose :first_name, documentation: {required: true}
        expect(generated_attr).to be_required
      end

      it 'defaults the required field to false' do
        entity.expose :first_name, documentation: {}
        expect(generated_attr).not_to be_required
      end
    end
  end
end

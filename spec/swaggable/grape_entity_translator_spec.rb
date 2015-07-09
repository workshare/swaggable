require_relative '../spec_helper'
require 'grape'
require 'grape-entity'

RSpec.describe 'Swaggable::GrapeEntityTranslator' do
  subject { Swaggable::GrapeEntityTranslator }

  describe '.parameter_from' do
    let(:generated_parameter) { subject.parameter_from entity }

    let(:entity) do
      Class.new(Grape::Entity) do
        expose :first_name

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
  end
end

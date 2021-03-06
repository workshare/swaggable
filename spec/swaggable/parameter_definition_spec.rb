require_relative '../spec_helper'

RSpec.describe 'Swaggable::ParameterDefinition' do
  let(:subject_class) { Swaggable::ParameterDefinition }
  let(:subject_instance) { Swaggable::ParameterDefinition.new }
  subject { subject_instance }

  it 'has a name' do
    subject.name = 'a name'
    expect(subject.name).to eq  'a name'
  end

  it 'coerces the name to string' do
    subject.name = :a_name
    expect(subject.name).to eq  'a_name'
  end

  it 'has a description' do
    subject.description = 'a new desc'
    expect(subject.description).to eq  'a new desc'
  end

  it 'has a required option' do
    subject.required = true
    expect(subject.required?).to be true
  end

  it 'yields itself on initialize' do
    yielded = false

    subject_class.new do |s|
      expect(s).to be_a subject_class
      yielded = true
    end

    expect(yielded).to be true
  end

  it 'yields itself on initialize' do
    subject = subject_class.new do
      name 'Some name'
    end

    expect(subject.name).to eq 'Some name'
  end

  describe '#location' do
    it 'can be set to :body, :header, :path, :query, :form' do
      [:body, :header, :path, :query, :form, nil].each do |location|
        subject.location = location
        expect(subject.location).to eq location
      end
    end

    it 'cannot be something other than that' do
      expect { subject.location = :xyz }.to raise_exception(ArgumentError)
    end
  end

  describe '#type' do
    it 'can be set to :string, :number, :integer, :boolean, :array, :file' do
      [:string, :number, :integer, :boolean, :array, :file, nil].each do |type|
        subject.type = type
        expect(subject.type).to eq type
      end
    end

    it 'cannot be something other than that' do
      expect { subject.type = :xyz }.to raise_exception(ArgumentError)
    end
  end

  it 'accepts attributes on initialize' do
    parameter = subject_class.new location: :path
    expect(parameter.location).to eq :path
  end

  it 'has schema definition' do
    subject.location :body

    subject.schema do
      name :user

      attributes do
        add_new do
          name :first_name
          type :string
        end
      end
    end

    expect(subject.schema.attributes[:first_name].type).to be :string
  end

  describe '#==' do
    it 'equals by name' do
      subject.name = 'a name'
      subject.location = :query

      expect(subject).to eq OpenStruct.new(name: 'a name', location: :query)
    end

    it 'doesn\'t throw error if comparing with any random object' do
      expect{ subject == double }.not_to raise_error
    end
  end

  it 'has a value' do
    subject.value = 10
    expect(subject.value).to eq 10
  end
end

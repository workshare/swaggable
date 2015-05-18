require_relative '../spec_helper'

RSpec.describe 'Swaggable::ParameterDefinition' do
  let(:subject_class) { Swaggable::ParameterDefinition }
  let(:subject_instance) { Swaggable::ParameterDefinition.new }
  subject { subject_instance }

  it 'has a name' do
    subject.name = 'a name'
    expect(subject.name).to eq  'a name'
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

  describe '#type' do
    it 'can be set to :body, :header, :path, :query' do
      pending 'Different types should be different classes'
      raise NotImplementedError
    end
  end
end

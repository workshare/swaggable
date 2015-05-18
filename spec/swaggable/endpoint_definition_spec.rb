require_relative '../spec_helper'

RSpec.describe 'Swaggable::EndpointDefinition' do
  let(:subject_class) { Swaggable::EndpointDefinition }
  let(:subject_instance) { Swaggable::EndpointDefinition.new }
  subject { subject_instance }

  it 'has a path' do
    subject.path = '/'
    expect(subject.path).to eq  '/'
  end

  it 'has a verb' do
    subject.verb = 'POST'
    expect(subject.verb).to eq  'POST'
  end

  it 'has a description' do
    subject.description = 'a new desc'
    expect(subject.description).to eq  'a new desc'
  end

  it 'has a summary' do
    subject.summary = 'a new summary'
    expect(subject.summary).to eq  'a new summary'
  end

  it 'has tags' do
    tag = instance_double(Swaggable::TagDefinition)
    subject.tags << tag
    expect(subject.tags).to eq  [tag]
  end

  it 'has consumes' do
    format = double('format')
    subject.consumes << format
    expect(subject.consumes).to eq  [format]
  end

  it 'has produces' do
    format = double('format')
    subject.produces << format
    expect(subject.produces).to eq  [format]
  end

  it 'has parameters' do
    parameter = instance_double(Swaggable::ParameterDefinition)
    subject.parameters << parameter
    expect(subject.parameters).to eq  [parameter]
  end

  it 'yields itself on initialize' do
    yielded = false

    subject_class.new do |s|
      expect(s).to be_a subject_class
      yielded = true
    end

    expect(yielded).to be true
  end
end

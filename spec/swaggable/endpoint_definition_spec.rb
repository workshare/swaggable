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
    tag = instance_double(Swaggable::TagDefinition, name: 'A Tag')
    subject.tags << tag
    expect(subject.tags.to_a).to eq  [tag]
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
    parameter = Swaggable::ParameterDefinition.new name: 'some_parameter'
    subject.parameters << parameter
    expect(subject.parameters.to_a).to eq  [parameter]
  end

  it 'yields itself on initialize' do
    yielded = false

    subject_class.new do |s|
      expect(s).to be_a subject_class
      yielded = true
    end

    expect(yielded).to be true
  end

  it 'accepts attributes on initialize' do
    endpoint = subject_class.new path: '/a/path', verb: 'GET'
    expect(endpoint.path).to eq '/a/path'
    expect(endpoint.verb).to eq 'GET'
  end

  it 'has responses' do
    subject.responses.add_new do
      status 418
      description 'Teapot'
    end

    expect(subject.responses[418].description).to eq 'Teapot'
  end
end

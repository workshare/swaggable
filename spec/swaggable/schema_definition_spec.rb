require_relative '../spec_helper'

RSpec.describe 'Swaggable::SchemaDefinition' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new }
  let(:subject_class) { Swaggable::SchemaDefinition }

  it 'has a name' do
    subject.name 'My Schema'
    expect(subject.name).to eq 'My Schema'
  end

  it 'has attributes' do
    subject.attributes.add_new do
      name :my_attr
      type :string
    end

    expect(subject.attributes[:my_attr].type).to be :string
  end

  it 'can be empty' do
    expect(subject).to be_empty

    subject.attributes.add_new do
      name :first_name
      type :string
    end

    expect(subject).not_to be_empty
  end

  it 'accepts attributes on initialize' do
    schema = subject_class.new name: 'New name'
    expect(schema.name).to eq 'New name'
  end

  it 'equals by name' do
    schema_1 = subject_class.new name: 'schema 1'
    schema_1_again = subject_class.new name: 'schema 1'
    schema_2 = subject_class.new name: 'schema 2'

    expect(schema_1).to eq schema_1_again
    expect([schema_1, schema_1_again].uniq.length).to eq 1
    expect(schema_1).not_to eq schema_2
  end

  it 'doesn\'t throw error if comparing with any random object' do
    expect{ subject == double }.not_to raise_error
  end
end

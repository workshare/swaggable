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
end

require_relative '../spec_helper'

RSpec.describe 'Swaggable::SchemaDefinition' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new }
  let(:subject_class) { Swaggable::SchemaDefinition }

  it 'can be instantiated' do
    expect{ subject }.not_to raise_error
  end

  it 'has attributes'
end

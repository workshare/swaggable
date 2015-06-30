require_relative '../spec_helper'

RSpec.describe 'Swaggable::ResponseDefinition' do
  let(:subject_class) { Swaggable::ResponseDefinition }
  let(:subject_instance) { Swaggable::ResponseDefinition.new }
  subject { subject_instance }

  it 'has a status' do
    subject.status = 418
    expect(subject.status).to eq 418
  end

  it 'has a description' do
    subject.description = "I'm a teapot"
    expect(subject.description).to eq "I'm a teapot"
  end
end

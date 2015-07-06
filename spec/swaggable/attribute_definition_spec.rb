require_relative '../spec_helper'

RSpec.describe 'Swaggable::AttributeDefinition' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new }
  let(:subject_class) { Swaggable::AttributeDefinition }

  it 'can be instantiated' do
    expect{ subject }.not_to raise_error
  end

  it 'has string type' do
    subject.type :string
    expect(subject.json_type).to be :string
    expect(subject.json_format).to be nil
  end

  it 'has integer type' do
    subject.type :integer
    expect(subject.json_type).to be :integer
    expect(subject.json_format).to be :int32
  end

  it 'has float type' do
    subject.type :float
    expect(subject.json_type).to be :number
    expect(subject.json_format).to be :float
  end

  it 'has long type' do
    subject.type :long
    expect(subject.json_type).to be :integer
    expect(subject.json_format).to be :int64
  end

  it 'has double type' do
    subject.type :double
    expect(subject.json_type).to be :number
    expect(subject.json_format).to be :double
  end

  it 'has byte type' do
    subject.type :byte
    expect(subject.json_type).to be :string
    expect(subject.json_format).to be :byte
  end

  it 'has boolean type' do
    subject.type :boolean
    expect(subject.json_type).to be :boolean
    expect(subject.json_format).to be nil
  end

  it 'has date type' do
    subject.type :date
    expect(subject.json_type).to be :string
    expect(subject.json_format).to be :date
  end

  it 'has date_time type' do
    subject.type :date_time
    expect(subject.json_type).to be :string
    expect(subject.json_format).to be :"date-time"
  end

  it 'has password type' do
    subject.type :password
    expect(subject.json_type).to be :string
    expect(subject.json_format).to be :password
  end

  it 'doesn\'t allow random types' do
    expect{ subject.type :asdfgh }.to raise_error(ArgumentError)
  end
end

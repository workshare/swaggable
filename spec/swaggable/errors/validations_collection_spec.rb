require_relative '../../spec_helper'

RSpec.describe 'Swaggable::Errors::ValidationsCollection' do
  let(:subject_class) { Swaggable::Errors::ValidationsCollection }
  let(:subject_instance) { subject_class.new }
  subject { subject_instance }
  let(:error) { new_error }

  def new_error *args
    Swaggable::Errors::Validation.new  *args
  end

  it 'can be instantiated' do
    subject
  end

  describe '#<<' do
    it 'adds Errors::Validation as is' do
      subject << error
      expect(subject.last).to be error
    end
  end

  describe '#each' do
    it 'iterates through the list' do
      subject << error

      list = []
      subject.each {|e| list << e }

      expect(list.last).to be error
    end
  end

  describe '#inspect' do
    it 'is readable' do
      subject << new_error('Problem 1')
      subject << new_error('Problem 2')
      expect(subject.inspect).to eq "#<Swaggable::Errors::ValidationsCollection: Problem 1. Problem 2.>"
    end
  end

  describe '#merge!' do
    it 'joins arrays' do
      other = subject_class.new

      error_1 = new_error
      error_2 = new_error

      subject << new_error

      subject.merge!([error_2])

      expect(subject.to_a).to eq [error_1, error_2]
    end
  end

  describe '#raise' do
  end
end

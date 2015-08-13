require_relative '../spec_helper'

RSpec.describe 'Swaggable::CheckMandatoryRackParameters' do
  subject { subject_instance }
  let(:subject_instance) { subject_class.new }
  let(:subject_class) { Swaggable::CheckMandatoryRackParameters }

  let(:parameters) { [] }
  let(:request) { {} }

  describe '.new' do
    it 'accepts initialization params' do
      subject = subject_class.new parameters: parameters, request: request
      expect(subject.parameters).to be parameters
      expect(subject.request).to be request
    end
  end

  describe '.call' do
    it 'delegates to errors on an instance of itself' do
      subject = double('subject')

      allow(subject_class).
        to receive(:new).
        with(parameters: parameters, request: request).
        and_return(subject)

      expect(subject).to receive(:errors).with(no_args)

      subject_class.call parameters: parameters, request: request
    end
  end

  describe '#errors' do
    context 'no mandatory params' do
      it 'returns an empty errors list'
    end

    context 'all mandatory params are present'
    context 'missing mandatory params'
    context 'missing non-mandatory params'
  end
end

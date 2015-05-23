require_relative '../spec_helper'

RSpec.describe 'EndpointIndex' do
  let(:subject_class) { Swaggable::EndpointIndex }
  let(:subject_instance) { Swaggable::EndpointIndex.new }
  subject { subject_instance }

  it 'accumulates endpoints with <<' do
    endpoint = Swaggable::EndpointDefinition.new verb: :get, path: '/'
    subject << endpoint
    expect(subject['GET /']).to be endpoint
  end

  it 'accumulates endpoints with add' do
    endpoint = Swaggable::EndpointDefinition.new verb: :get, path: '/'
    subject.add endpoint
    expect(subject['GET /']).to be endpoint
  end

  it 'adds new endpoints' do
    endpoint = subject.add_new do |e|
      e.verb = :post
      e.path = '/users'
    end

    expect(subject['POST /users']).to be endpoint
  end

  it 'iterates through endpoints' do
    has_run = false

    endpoint = subject.add_new do |e|
      e.verb = :post
      e.path = '/users'
    end

    subject.each do |e|
      has_run = true
      expect(e).to be endpoint
    end
  end

  it 'converts to array' do
    endpoint = subject.add_new do |e|
      e.verb = :post
      e.path = '/users'
    end

    expect(subject.to_a).to eq [endpoint]
  end

  it 'clears' do
    endpoint = subject.add_new do |e|
      e.verb = :post
      e.path = '/users'
    end

    subject.clear

    expect(subject.to_a).to eq []
  end
end

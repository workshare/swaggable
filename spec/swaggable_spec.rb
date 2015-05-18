require_relative 'spec_helper'

RSpec.describe 'Swaggable' do
  it 'has a VERSION' do
    expect(Swaggable::VERSION).not_to be_nil
  end
end

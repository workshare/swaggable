require 'rubygems'
require 'rspec'
require 'pry'
require 'webmock/rspec'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.disable_monkey_patching!
  # config.full_backtrace = true
  # config.formatter = :documentation # :documentation, :progress, :html, :textmate

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

WebMock.disable_net_connect!(:allow => "codeclimate.com")

if !!ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

$LOAD_PATH.unshift File.expand_path('lib')
require 'swaggable'

$LOAD_PATH.unshift File.expand_path('spec/support')


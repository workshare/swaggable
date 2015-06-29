require 'rubygems'
require 'rspec'
require 'pry'
require 'webmock/rspec'

RSpec.configure do |config|
   config.color = true
   config.tty = true
   config.disable_monkey_patching!
   # config.formatter = :documentation # :documentation, :progress, :html, :textmate
end

$LOAD_PATH.unshift File.expand_path('lib')
require 'swaggable'

$LOAD_PATH.unshift File.expand_path('spec/support')


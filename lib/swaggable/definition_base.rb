module Swaggable
  module DefinitionBase
    def self.included klass
      klass.include ForwardingDsl::Getsetter
      klass.include EnumerableAttributes
    end

    def initialize args = {}
      args.each {|k, v| self.send("#{k}=", v) }
      yield self if block_given?
    end
  end
end

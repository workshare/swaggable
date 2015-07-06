module Swaggable
  module DefinitionBase
    def self.included klass
      klass.send :include, ForwardingDsl::Getsetter
      klass.send :include, EnumerableAttributes
    end

    def initialize args = {}
      args.each {|k, v| self.send("#{k}=", v) }
      yield self if block_given?
    end
  end
end

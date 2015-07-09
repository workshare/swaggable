require 'forwarding_dsl'

module Swaggable
  module DefinitionBase
    def self.included klass
      klass.send :include, ForwardingDsl::Getsetter
      klass.send :include, EnumerableAttributes
    end

    def initialize args = {}, &block
      args.each {|k, v| self.send("#{k}=", v) }
      ForwardingDsl.run(self, &block)
    end
  end
end

require 'forwarding_dsl'

module Swaggable
  class ResponseDefinition
    include ForwardingDsl::Getsetter

    getsetter :status
    getsetter :description

    def initialize args = {}
      args.each {|k, v| self.send("#{k}=", v) }
      yield self if block_given?
    end
  end
end


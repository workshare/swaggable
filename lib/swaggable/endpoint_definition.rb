require 'forwarding_dsl'
require 'mini_object'

module Swaggable
  class EndpointDefinition
    include DefinitionBase

    getsetter(
      :path,
      :verb,
      :description,
      :summary,
    )

    def tags
      @tags ||= MiniObject::IndexedList.new.tap do |l|
        l.build { TagDefinition.new }
        l.key {|e| e.name }
      end
    end

    def parameters
      @parameters ||= MiniObject::IndexedList.new.tap do |l|
        l.build { ParameterDefinition.new }
        l.key {|e| e.name }
      end
    end

    def responses
      @responses ||= MiniObject::IndexedList.new.tap do |l|
        l.build { ResponseDefinition.new }
        l.key {|e| e.status }
      end
    end

    def consumes
      @consumes ||= Set.new
    end

    def produces
      @produces ||= Set.new
    end

    def configure &block
      ForwardingDsl.run(self, &block)
      self
    end
  end
end

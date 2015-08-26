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

    def initialize *args, &block
      self.verb = 'GET'
      super *args, &block
    end

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
      @consumes ||= MimeTypesCollection.new
    end

    def produces
      @produces ||= MimeTypesCollection.new
    end

    def configure &block
      ForwardingDsl.run(self, &block)
      self
    end

    def match? v, p
      v.to_s.upcase == verb.to_s.upcase && !!(path_template.match p)
    end

    def verb= value
      @verb = value.to_s.upcase
    end

    def path_parameters_for path
      path_template.extract(path) || {}
    end

    def body
      parameters.detect {|p| p.location == :body }
    end

    private

    def path_template
      Addressable::Template.new path
    end
  end
end

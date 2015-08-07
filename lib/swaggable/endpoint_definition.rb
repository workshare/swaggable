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
      @consumes ||= Set.new
    end

    def produces
      @produces ||= Set.new
    end

    def configure &block
      ForwardingDsl.run(self, &block)
      self
    end

    def match? v, p
      v.to_s.upcase == verb.to_s.upcase && !!(p =~ path_regexp)
    end

    def verb= value
      @verb = value.to_s.upcase
    end

    private

    def path_regexp
      Regexp.new(Regexp.escape(path).gsub(/\\{[a-zA-Z\-_\d]*\\}/, '[a-zA-Z\\-_\\d]+'))
    end
  end
end

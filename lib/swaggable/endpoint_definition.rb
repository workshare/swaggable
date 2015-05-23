module Swaggable
  class EndpointDefinition
    attr_accessor(
      :path,
      :verb,
      :description,
      :summary,
    )

    def initialize args = {}
      args.each {|k, v| self.send("#{k}=", v) }
      yield self if block_given?
    end

    def tags
      @tags ||= IndexedList.new.tap do |l|
        l.build { TagDefinition.new }
        l.key {|e| e.name }
      end
    end

    def parameters
      @parameters ||= []
    end

    def consumes
      @consumes ||= []
    end

    def produces
      @produces ||= []
    end
  end
end

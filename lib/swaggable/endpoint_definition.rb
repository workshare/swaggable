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
      @tags ||= []
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

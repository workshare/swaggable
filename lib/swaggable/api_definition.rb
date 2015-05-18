module Swaggable
  class ApiDefinition
    attr_accessor(
      :version,
      :title,
      :description,
      :base_path,
    )

    def initialize
      yield self if block_given?
    end

    def endpoints
      @endpoints ||= []
    end

    def tags
      endpoints.map(&:tags).reduce(:|) || []
    end

    def self.from_grape_api grape
      raise NotImplementedError
    end
  end
end

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
      grape_adapter.import(new, grape)
    end

    def self.grape_adapter
      @grape_adapter ||= Swaggable::GrapeAdapter.new
    end
  end
end

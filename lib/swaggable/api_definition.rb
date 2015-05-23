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
      @endpoints ||= IndexedList.new.tap do |l|
        l.build { EndpointDefinition.new }
        l.key {|e| "#{e.verb.to_s.upcase} #{e.path}" }
      end
    end

    def tags
      (endpoints.map(&:tags).reduce(:|) || []).freeze
    end

    def self.from_grape_api grape
      grape_adapter.import(grape, new)
    end

    def self.grape_adapter
      @grape_adapter ||= Swaggable::GrapeAdapter.new
    end
  end
end

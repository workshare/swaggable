require 'forwarding_dsl'

module Swaggable
  class ApiDefinition
    include ForwardingDsl::Getsetter

    getsetter(
      :version,
      :title,
      :description,
      :base_path,
    )

    def initialize &block
      configure(&block) if block_given?
    end

    def endpoints &block
      ForwardingDsl.run(
        @endpoints ||= build_endpoints, 
        &block
      )
    end

    def tags
      (endpoints.map(&:tags).reduce(:merge) || []).dup.freeze
    end

    def self.from_grape_api grape
      grape_adapter.import(grape, new)
    end

    def self.grape_adapter
      @grape_adapter ||= Swaggable::GrapeAdapter.new
    end

    def configure &block
      ForwardingDsl.run(self, &block)
      self
    end

    private

    def build_endpoints
      IndexedList.new.tap do |l|
        l.build { EndpointDefinition.new }
        l.key {|e| "#{e.verb.to_s.upcase} #{e.path}" }
      end
    end
  end
end

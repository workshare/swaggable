module Swaggable
  class EndpointIndex
    include Enumerable

    def << e
      store["#{e.verb.to_s.upcase} #{e.path}"] = e
    end

    alias add <<

    def add_new
      e = EndpointDefinition.new
      yield e
      add e
    end

    def [] key
      store[key]
    end

    def each &block
      store.values.each &block
    end

    def clear
      store.clear
    end

    private

    def store
      @store ||= {}
    end
  end
end

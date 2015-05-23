module Swaggable
  class IndexedList
    include Enumerable

    def key &block
      @key_proc = block
    end

    def build &block
      @build_proc = block
    end

    def << e
      store[key_for(e)] = e
    end

    alias add <<

    def add_new
      e = build_new
      yield e
      add e
    end

    def [] key
      store.values.detect {|e| key_for(e) == key }
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

    def key_for e
      @key_proc.call e
    end

    def build_new *args
      @build_proc.call *args
    end
  end
end

module Swaggable
  class MimeTypesCollection
    include Enumerable
    extend Forwardable

    def_delegators(
      :@list,
      :last,
      :first,
      :count,
    )

    def initialize
      @list = []
    end

    def << entry
      entry = case entry
              when Symbol, String then MimeTypeDefinition.new entry
              else entry
              end

      if n = list.index(entry)
        list[n] = entry
      else
        list << entry
      end
    end

    def each *args, &block
      list.each(*args, &block)
    end

    def [] key
      list.detect {|e| e == key }
    end

    def inspect
      "#<Swaggable::MimeTypesCollection: #{list.map(&:name).join(', ')}>"
    end

    private

    attr_reader :list
  end
end

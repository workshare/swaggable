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

    def merge! other
      other.each {|e| self << e }
    end

    def == other
      count == other.count && other.each {|e| include? e }
    end

    alias eql? ==

    def hash
      name.hash
    end

    protected

    attr_reader :list
  end
end

module Swaggable
  module Errors
    class ValidationsCollection
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
        list << entry
      end

      def each *args, &block
        list.each(*args, &block)
      end

      def inspect
        "#<#{self.class.name}: #{list.map(&:message).join('. ')}.>"
      end

      def merge! other
        other.each {|e| self << e }
      end

      protected

      attr_reader :list
    end
  end
end

require "forwardable"

module Swaggable
  module Errors
    class ValidationsCollection < Validation
      include Enumerable
      extend Forwardable

      def_delegators(
        :@list,
        :last,
        :first,
        :count,
        :empty?,
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
        "#<#{self.class.name}: #{message}>"
      end

      def merge! other
        other.each {|e| self << e }
      end

      def message
        list.map(&:message).join('. ') + '.'
      end

      protected

      attr_reader :list
    end
  end
end

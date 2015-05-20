module Swaggable
  class TagDefinition
    attr_accessor(
      :name,
      :description,
    )

    def initialize args = {}
      args.each {|k, v| self.send("#{k}=", v) }
      yield self if block_given?
    end

    def == other
      self.name == other.name if other.respond_to?(:name)
    end
    alias eql? ==

    def hash
      name.hash
    end
  end
end


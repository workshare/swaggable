module Swaggable
  class TagDefinition
    attr_accessor(
      :name,
      :description,
    )

    def initialize
      yield self if block_given?
    end
  end
end

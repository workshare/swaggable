require 'forwarding_dsl'

module Swaggable
  class TagDefinition
    include DefinitionBase

    getsetter(
      :name,
      :description,
    )

    def == other
      self.name == other.name if other.respond_to?(:name)
    end
    alias eql? ==

    def hash
      name.hash
    end
  end
end


module Swaggable
  class ParameterDefinition
    attr_accessor(
      :name,
      :description,
      :type,
      :required,
    )

    def initialize
      yield self if block_given?
    end

    def required?
      !!required
    end
  end
end

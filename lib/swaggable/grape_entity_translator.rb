module Swaggable
  module GrapeEntityTranslator
    extend self

    def parameter_from entity
      ParameterDefinition.new do
        location :body
        this.name entity.name
      end
    end
  end
end

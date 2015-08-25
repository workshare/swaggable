require 'mini_object'

module Swaggable
  class ParameterDefinition
    include DefinitionBase

    getsetter(
      :name,
      :description,
      :required,
      :type,
      :schema,
    )

    attr_enum :location, [:path, :query, :header, :body, :form, nil]
    attr_enum :type, [:string, :number, :integer, :boolean, :array, :file, nil]

    def required?
      !!required
    end

    def schema &block
      ForwardingDsl.run(
        @schema ||= build_schema,
        &block
      )
    end

    def name= value
      @name = value.to_s
    end

    private

    def build_schema
      SchemaDefinition.new
    end
  end
end

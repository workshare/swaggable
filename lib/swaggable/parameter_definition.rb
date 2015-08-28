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
      :value,
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

    def == other
      if other.respond_to?(:name) && other.respond_to?(:location)
        [name, location] == [other.name, other.location]
      else
        false
      end
    end

    alias eql? ==

    def hash
      [name, location].hash
    end

    private

    def build_schema
      SchemaDefinition.new
    end
  end
end

require 'mini_object'

module Swaggable
  class ParameterDefinition
    include DefinitionBase

    getsetter(
      :name,
      :description,
      :required,
      :type,
    )

    attr_enum :location, [:path, :query, :header, :body, :form, nil]
    attr_enum :type, [:string, :number, :integer, :boolean, :array, :file, nil]

    def required?
      !!required
    end
  end
end

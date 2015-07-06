require 'mini_object'

module Swaggable
  class ParameterDefinition
    include DefinitionBase

    getsetter(
      :name,
      :description,
      :location,
      :required,
      :type,
    )

    def required?
      !!required
    end

    def location= location
      unless valid_locations.include? location
        raise ArgumentError.new("#{location} is not one of the valid locations: #{valid_locations.join(", ")}")
      end

      @location = location
    end

    def type= type
      unless valid_types.include? type
        raise ArgumentError.new("#{type} is not one of the valid types: #{valid_types.join(", ")}")
      end

      @type = type
    end

    private

    def valid_locations
      [:path, :query, :header, :body, :form, nil]
    end

    def valid_types
      [:string, :number, :integer, :boolean, :array, :file, nil]
    end
  end
end

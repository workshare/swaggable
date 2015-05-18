module Swaggable
  class ParameterDefinition
    attr_accessor(
      :name,
      :description,
      :location,
      :required,
    )

    def initialize
      yield self if block_given?
    end

    def required?
      !!required
    end

    def location= location
      unless valid_locations.include? location
        raise ArgumentError.new("#{location} is not one of the valid locations: #{valid_locations.join(", ")}")
      end

      @location = location
    end

    private

    def valid_locations
      [:path, :query, :header, :body, :form]
    end
  end
end

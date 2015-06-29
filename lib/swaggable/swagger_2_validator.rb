require 'json_schema'

module Swaggable
  class Swagger2Validator
    def self.schema
      @schema = File.dirname(__FILE__) + '/../../assets/swagger-2.0-schema.json'
    end

    def self.validate! data
      schema_data = JSON.parse(File.read(schema))
      schema = JsonSchema.parse!(schema_data)
      valid, errors = schema.validate(data)

      if valid
        true
      else
        raise ValidationError.new(errors)
      end
    end

    class ValidationError < StandardError
      def initialize errors
        @errors = errors
      end

      def message
        @errors.map(&:to_s).join(" ")
      end
    end

  end
end

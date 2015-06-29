require 'json-schema'

module Swaggable
  class Swagger2Validator
    def self.schema
      @schema = File.dirname(__FILE__) + '/../../assets/swagger-2.0-schema.json'
    end

    def self.validate! swagger
      # This will cache draft4 to avoid downloading it
      JSON::Validator.validate!(JSON.parse(File.read('assets/json-schema-draft-04.json')), {})

      JSON::Validator.validate!(schema, swagger)
    end
  end
end

require 'json-schema'

module Swaggable
  class Swagger2Validator
    def self.validate! swagger
      preload_draft4
      JSON::Validator.validate!(schema, swagger)
    end

    private

    def self.schema
      @schema = assets_dir + '/swagger-2.0-schema.json'
    end

    def self.draft4
      @draft4 = assets_dir + '/json-schema-draft-04.json'
    end

    def self.assets_dir
      File.dirname(__FILE__) + '/../../assets'
    end

    def self.preload_draft4
      @draft4_preloaded ||= JSON::Validator.validate!(draft4, {})
    end
  end
end

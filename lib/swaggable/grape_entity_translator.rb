module Swaggable
  module GrapeEntityTranslator
    def self.parameter_from entity
      ParameterDefinition.new do
        location :body
        name entity.name

        entity.exposures.each do |name, opts|
          schema.attributes.add_new do
            this.name name
            type type_from_options(opts)
            description description_from_options(opts)
          end
        end
      end
    end

    private

    def self.type_from_options opts
      documentation = opts[:documentation] || {}
      type = documentation[:type] || 'string'
      type.downcase.to_sym
    end

    def self.description_from_options opts
      documentation = opts[:documentation] || {}
      documentation[:desc]
    end
  end
end

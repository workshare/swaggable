require 'swaggable/version'

module Swaggable
  autoload :ApiDefinition, 'swaggable/api_definition'
  autoload :EndpointDefinition, 'swaggable/endpoint_definition'
  autoload :ParameterDefinition, 'swaggable/parameter_definition'
  autoload :TagDefinition, 'swaggable/tag_definition'
  autoload :ResponseDefinition, 'swaggable/response_definition'
  autoload :RackApp, 'swaggable/rack_app'
  autoload :GrapeAdapter, 'swaggable/grape_adapter'
  autoload :GrapeEntityTranslator, 'swaggable/grape_entity_translator'
  autoload :Swagger2Serializer, 'swaggable/swagger_2_serializer'
  autoload :Swagger2Validator, 'swaggable/swagger_2_validator'
  autoload :EndpointIndex, 'swaggable/endpoint_index'
  autoload :DefinitionBase, 'swaggable/definition_base'
  autoload :EnumerableAttributes, 'swaggable/enumerable_attributes'
  autoload :SchemaDefinition, 'swaggable/schema_definition'
  autoload :AttributeDefinition, 'swaggable/attribute_definition'
end

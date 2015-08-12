require 'swaggable/version'

module Swaggable
  autoload :ApiDefinition, 'swaggable/api_definition'
  autoload :EndpointDefinition, 'swaggable/endpoint_definition'
  autoload :ParameterDefinition, 'swaggable/parameter_definition'
  autoload :TagDefinition, 'swaggable/tag_definition'
  autoload :ResponseDefinition, 'swaggable/response_definition'
  autoload :MimeTypeDefinition, 'swaggable/mime_type_definition'
  autoload :MimeTypesCollection, 'swaggable/mime_types_collection'
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
  autoload :RackRedirect, 'swaggable/rack_redirect'
  autoload :Errors, 'swaggable/errors'
  autoload :ValidatingRackApp, 'swaggable/validating_rack_app'
  autoload :ApiRackValidator, 'swaggable/api_rack_validator'
  autoload :EndpointRackValidator, 'swaggable/endpoint_rack_validator'
end

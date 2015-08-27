require 'swaggable/version'

module Swaggable
  # Rack
  autoload :RackApp, 'swaggable/rack_app'
  autoload :RackRedirect, 'swaggable/rack_redirect'
  autoload :ValidatingRackApp, 'swaggable/validating_rack_app'
  autoload :RackRequestAdapter, 'swaggable/rack_request_adapter'
  autoload :RackResponseAdapter, 'swaggable/rack_response_adapter'

  # Definitions
  autoload :DefinitionBase, 'swaggable/definition_base'
  autoload :ApiDefinition, 'swaggable/api_definition'
  autoload :EndpointDefinition, 'swaggable/endpoint_definition'
  autoload :TagDefinition, 'swaggable/tag_definition'
  autoload :ParameterDefinition, 'swaggable/parameter_definition'
  autoload :ResponseDefinition, 'swaggable/response_definition'
  autoload :MimeTypeDefinition, 'swaggable/mime_type_definition'
  autoload :MimeTypesCollection, 'swaggable/mime_types_collection'
  autoload :SchemaDefinition, 'swaggable/schema_definition'
  autoload :AttributeDefinition, 'swaggable/attribute_definition'

  # Grape
  autoload :GrapeAdapter, 'swaggable/grape_adapter'
  autoload :GrapeEntityTranslator, 'swaggable/grape_entity_translator'

  # Swagger
  autoload :Swagger2Serializer, 'swaggable/swagger_2_serializer'
  autoload :Swagger2Validator, 'swaggable/swagger_2_validator'

  # Validators
  autoload :ApiValidator, 'swaggable/api_validator'
  autoload :EndpointValidator, 'swaggable/endpoint_validator'
  autoload :CheckRequestContentType, 'swaggable/check_request_content_type'
  autoload :CheckMandatoryParameters, 'swaggable/check_mandatory_parameters'
  autoload :CheckExpectedParameters, 'swaggable/check_expected_parameters'
  autoload :CheckBodySchema, 'swaggable/check_body_schema'
  autoload :CheckResponseContentType, 'swaggable/check_response_content_type'

  # Others
  autoload :Errors, 'swaggable/errors'
  autoload :EnumerableAttributes, 'swaggable/enumerable_attributes'
  autoload :QueryParams, 'swaggable/query_params'
end

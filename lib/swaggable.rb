require 'swaggable/version'

module Swaggable
  autoload :ApiDefinition, 'swaggable/api_definition'
  autoload :EndpointDefinition, 'swaggable/endpoint_definition'
  autoload :ParameterDefinition, 'swaggable/parameter_definition'
  autoload :TagDefinition, 'swaggable/tag_definition'
  autoload :RackApp, 'swaggable/rack_app'
  autoload :GrapeAdapter, 'swaggable/grape_adapter'
  autoload :Swagger2Serializer, 'swaggable/swagger_2_serializer'
  autoload :Swagger2Validator, 'swaggable/swagger_2_validator'
  autoload :EndpointIndex, 'swaggable/endpoint_index'
  autoload :IndexedList, 'swaggable/endpoint_index'
end

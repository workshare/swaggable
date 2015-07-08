module Swaggable
  # Generates a Swagger 2 hash from an {ApiDefinition}.
  #
  # @example Basic usage
  #   serializer = Swagger2Serializer.new
  #   api_definition = ApiDefinition.new
  #   serializer.serialize(api_definition)
  #   # => {:swagger=>"2.0", :basePath=>nil, :info=>{:title=>nil, :description=>nil, :version=>nil}, :tags=>[], :paths=>{}}
  #
  class Swagger2Serializer
    attr_accessor :tag_serializer

    # Main method that given an {ApiDefinition} will return a hash to serialize
    def serialize api
      {
        swagger: '2.0',
        basePath: api.base_path,
        info: serialize_info(api),
        tags: api.tags.map{|t| serialize_tag t },
        paths: serialize_endpoints(api.endpoints),
        definitions: serialize_definitions(api),
      }
    end

    def serialize_info api
      {
        title: api.title.to_s,
        version: (api.version || '0.0.0'),
      }.
      tap do |h|
        h[:description] = api.description if api.description
      end
    end

    def serialize_tag tag
      {
        name: tag.name,
      }.
      tap do |e|
        e[:description] = tag.description if tag.description
      end
    end

    def serialize_endpoints endpoints
      endpoints.inject({}) do |out, endpoint|
        out[endpoint.path] ||= {}
        out[endpoint.path][endpoint.verb] = serialize_endpoint(endpoint)
        out
      end
    end

    def serialize_endpoint endpoint
      {
        tags: endpoint.tags.map(&:name),
        consumes: endpoint.consumes,
        produces: endpoint.produces,
        parameters: endpoint.parameters.map{|p| serialize_parameter p },
        responses: serialize_responses(endpoint.responses),
      }.
      tap do |e|
        e[:summary] = endpoint.summary if endpoint.summary
        e[:description] = endpoint.description if endpoint.description
      end
    end

    def serialize_parameter parameter
      p = {
        in: parameter.location.to_s,
        name: parameter.name,
        required: parameter.required?,
      }

      p[:type] = parameter.type || 'string' unless parameter.location == :body
      p[:description] = parameter.description if parameter.description

      unless parameter.schema.empty?
        p[:schema] = {:"$ref" => "#/definitions/#{parameter.schema.name}"}
      end

      p
    end

    def serialize_parameter_schema schema
      out = {type: 'object'}

      out[:properties] = schema.attributes.inject({}) do |acc, attribute|
        acc[attribute.name] = serialize_parameter_attribute attribute
        acc
      end

      out
    end

    def serialize_parameter_attribute attribute
      {
        type: attribute.json_type,
      }.
      tap do |e|
        e[:description] = attribute.description if attribute.description
        e[:format] = attribute.json_format if attribute.json_format
      end
    end

    def serialize_responses responses
      if responses.any?
        responses.inject({}) do |acc, r|
          acc[r.status] = {description: r.description}
          acc
        end
      else
        {200 => {description: 'Success'}}
      end
    end

    def serialize_definitions api
      api.used_schemas.inject({}) do |acc, schema|
        acc[schema.name] = serialize_parameter_schema schema
        acc
      end
    end

    def validate! api
      Swagger2Validator.validate! serialize(api)
    end

    def validate api
      Swagger2Validator.validate serialize(api)
    end
  end
end

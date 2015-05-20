module Swaggable
  class Swagger2Serializer
    attr_accessor :tag_serializer

    def serialize api
      {
        swagger: '2.0',
        basePath: api.base_path,
        info: {
          title: api.title,
          description: api.description,
          version: api.version,
        },
        tags: api.tags.map{|t| serialize_tag t },
        paths: serialize_endpoints(api.endpoints),
      }
    end

    def serialize_tag tag
      {
        name: tag.name,
        description: tag.description,
      }
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
        description: endpoint.description,
        summary: endpoint.summary,
        tags: endpoint.tags.map(&:name),
        consumes: endpoint.consumes,
        produces: endpoint.produces,
        parameters: endpoint.parameters.map{|p| serialize_parameter p },
      }
    end

    def serialize_parameter parameter
      p = {
        in: parameter.location.to_s,
        name: parameter.name,
        description: parameter.description,
        required: parameter.required?,
      }

      p[:type] = parameter.type if parameter.type
      p
    end
  end
end

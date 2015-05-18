module Swaggable
  class GrapeAdapter
    def import grape, api
      api.version = grape.version
      api.title = grape.name
      api.base_path = '/'

      grape.routes.each do |grape_endpoint|
        api.endpoints << EndpointDefinition.new do |api_endpoint|
          api_endpoint.verb = grape_endpoint.route_method
          api_endpoint.description = grape_endpoint.route_description
          api_endpoint.produces << "application/#{grape.format}" if grape.format
          api_endpoint.path = extract_path(grape_endpoint, grape)
        end
      end

      #   e.path = grape_route.route_path.
      #     gsub(/^\/#{grape_route.route_prefix}\/:version\//, "/#{grape_route.route_prefix}/#{grape_route.route_version}/").
      #   gsub(/\(\.:format\)$/,'')

      #   grape_route.route_compiled.names.each do |name|
      #     e.path = e.path.gsub(/:#{name}/, "{#{name}}")
      #   end
    end

    def extract_path grape_endpoint, grape
      path = grape_endpoint.route_path
      path = remove_format_from_path(path)
      path = remove_prefix_from_path(path, grape.prefix)
    end

    def remove_format_from_path path
      path.gsub(/\(\.:format\)$/,'')
    end

    def remove_prefix_from_path path, prefix
      path
    end
  end
end

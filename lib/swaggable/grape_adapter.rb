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

          grape_endpoint.route_params.each do |name, options|
            api_endpoint.parameters << parameter_from(name, options)
          end
        end
      end
    end

    private

    def extract_path grape_endpoint, grape
      path = grape_endpoint.route_path
      path = remove_format_from_path(path)
      path = substitute_version_in_path(path, grape)
      substitute_parameters_in_path(path, grape_endpoint)
    end

    def remove_format_from_path path
      path.gsub(/\(\.:format\)$/,'')
    end

    def substitute_version_in_path path, grape
      path.gsub(/^#{Regexp.escape grape.prefix.to_s}\/:version\//,"#{grape.prefix}/#{grape.version}/")
    end

    def substitute_parameters_in_path path, grape_endpoint
      path = path.dup

      grape_endpoint.route_compiled.names.each do |name|
        path.gsub!(/:#{name}/, "{#{name}}")
      end

      path
    end

    def parameter_from name, options
      Swaggable::ParameterDefinition.new do |p|
        options = {} if options == ''

        p.name = name
        p.type = options[:type].downcase.to_sym if options[:type]
        p.required = options[:required]
        p.description = options[:desc]
      end
    end
  end
end

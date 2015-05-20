module Swaggable
  class GrapeAdapter
    def import grape, api
      api.version = grape.version
      api.title = grape.name
      api.base_path = '/'

      grape.routes.each do |grape_endpoint|
        api.endpoints << EndpointDefinition.new do |api_endpoint|
          api_endpoint.verb = grape_endpoint.route_method.downcase
          api_endpoint.description = grape_endpoint.route_description
          api_endpoint.produces << "application/#{grape.format}" if grape.format
          api_endpoint.path = extract_path(grape_endpoint, grape)
          api_endpoint.tags << Swaggable::TagDefinition.new(name: grape.name)

          grape_endpoint.route_params.each do |name, options|
            api_endpoint.parameters << parameter_from(name, options, grape_endpoint)
          end
        end
      end

      api
    end

    private

    def extract_path grape_endpoint, grape
      path = grape_endpoint.route_path
      path = remove_format_from_path(path)
      path = substitute_version_in_path(path, grape)
      substitute_parameters_in_path(path, grape_endpoint)
    end

    def remove_format_from_path path
      path.gsub(/\(\/{0,1}\.:format\)$/,'')
    end

    def substitute_version_in_path path, grape
      prefix = "/#{grape.prefix.to_s}".gsub(/^\/\//,'/')
      prefix = '' if prefix == '/'
      path.gsub(/^#{Regexp.escape prefix}\/:version/,"#{prefix}/#{grape.version}")
    end

    def substitute_parameters_in_path path, grape_endpoint
      path = path.dup

      grape_endpoint.route_compiled.names.each do |name|
        path.gsub!(/:#{name}/, "{#{name}}")
      end

      path
    end

    def parameter_from name, options, grape_endpoint
      Swaggable::ParameterDefinition.new do |p|
        options = {} if options == ''

        p.name = name
        p.type = options[:type].downcase.to_sym if options[:type]
        p.required = options[:required]
        p.description = options[:desc]
        p.location = :path if grape_endpoint.route_compiled.names.include? name
      end
    end
  end
end

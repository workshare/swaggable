module Swaggable
  class GrapeAdapter
    def import grape, api
      api.version = grape.version
      api.title = grape.name
      api.base_path = '/'

      grape.routes.each do |grape_endpoint|
        api.endpoints.add_new do |api_endpoint|
          import_endpoint grape_endpoint, api_endpoint, grape
        end
      end

      api
    end

    private

    def extract_path grape_endpoint, grape
      path = grape_endpoint.path
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

      grape_endpoint.pattern.to_regexp.names.each do |name|
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
        p.location = if grape_endpoint.pattern.to_regexp.names.include? name
                       :path
                     else
                       :query
                     end
      end
    end

    def import_endpoint grape_endpoint, api_endpoint, grape
      api_endpoint.verb = grape_endpoint.request_method.downcase
      api_endpoint.summary = grape_endpoint.description
      api_endpoint.path = extract_path(grape_endpoint, grape)

      api_endpoint.produces.merge! grape.content_types.values
      api_endpoint.consumes.merge! grape.content_types.values

      api_endpoint.tags.add_new do |t|
        t.name = grape.name
      end

      grape_endpoint.params.each do |name, options|
        api_endpoint.parameters << parameter_from(name, options, grape_endpoint)
      end

      if entity = grape_endpoint.entity
        api_endpoint.parameters << GrapeEntityTranslator.parameter_from(entity)
      end

      (grape_endpoint.http_codes || []).each do |status, desc, entity|
        api_endpoint.responses.add_new do |r|
          r.status = status
          r.description = desc
        end
      end
    end
  end
end

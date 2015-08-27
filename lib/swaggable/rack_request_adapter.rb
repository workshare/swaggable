require 'json'
require 'ostruct'

module Swaggable
  class RackRequestAdapter
    def initialize env
      @env = env || raise("env hash is required")
    end

    def [] key
      env[key]
    end

    def query_parameters
      @query_parameters ||= QueryParams.new env['QUERY_STRING']
    end

    def query_parameters= p
      @query_parameters = QueryParams.new p
    end

    def path
      env['PATH_INFO']
    end

    def body
      @body ||= if stream = env['rack.input']
                  string = stream.read
                  string == '' ? nil : string
                else
                  nil
                end
    end

    def parsed_body
      case content_type
      when 'application/json' then JSON.parse body
      else
        raise "Don't know how to parse #{env['CONTENT_TYPE'].inspect}"
      end
    end

    def parameters endpoint = endpoint_stub
      build_path_parameters(endpoint) +
      build_query_parameters
    end

    def content_type
      env['CONTENT_TYPE']
    end

    def content_type= value
      env['CONTENT_TYPE'] = value
    end

    private

    attr_reader :env

    def rack_request
      @rack_request = Rack::Request.new env
    end

    def build_query_parameters
      query_parameters.map do |name, value|
        ParameterDefinition.new(name: name, value: value, location: :query)
      end
    end

    def build_path_parameters endpoint
      if endpoint
        endpoint.path_parameters_for(path).map do |name, value|
          ParameterDefinition.new(name: name, value: value, location: :path)
        end
      else
        []
      end
    end

    def endpoint_stub
      Object.new.tap do |o|
        def o.path_parameters_for _
          {}
        end
      end
    end
  end
end

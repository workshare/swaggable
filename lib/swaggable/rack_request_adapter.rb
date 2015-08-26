require 'json'

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
      case env['CONTENT_TYPE']
      when 'application/json' then JSON.parse body
      else
        raise "Don't know how to parse #{env['CONTENT_TYPE'].inspect}"
      end
    end

    private

    attr_reader :env

    def rack_request
      @rack_request = Rack::Request.new env
    end
  end
end

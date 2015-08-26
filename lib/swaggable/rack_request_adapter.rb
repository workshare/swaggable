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

    def parameters
      query_parameters
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

  class QueryParams < Delegator
    def initialize arg = nil
      case arg
      when String then self.string = arg
      when Hash then self.hash = arg
      when NilClass then self.hash = {}
      else raise("#{arg.inspect} not supported. Use Hash or String")
      end
    end

    def __getobj__
      hash
    end

    def string
      @string
    end

    def hash
      parse(string).freeze
    end

    def string= value
      @string = value
    end

    def hash= value
      self.string = serialize(value)
    end

    def []= key, value
      self.hash= hash.merge(key => value)
    end

    private

    def serialize hash
      hash.map{|k, v| "#{k}=#{v}" }.join("&")
    end

    def parse string
      Hash[string.split("&").map{|s| s.split("=") }]
    end
  end
end

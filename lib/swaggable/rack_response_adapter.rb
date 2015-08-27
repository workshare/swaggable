module Swaggable
  class RackResponseAdapter
    def initialize rack_response = default_rack_response
      @rack_response = rack_response
    end

    def content_type
      rack_headers['Content-Type']
    end

    def content_type= value
      rack_headers['Content-Type'] = value
    end

    def code
      rack_response[0]
    end

    def code= value
      rack_response[0] = value
    end

    def == other
      if other.respond_to? :rack_response, true
        rack_response == other.rack_response
      else
        false
      end
    end

    alias eql? ==

    def hash
      rack_response.hash
    end

    protected

    attr_accessor :rack_response

    def default_rack_response
      [200, {}, []]
    end

    def rack_headers
      rack_response[1]
    end
  end
end

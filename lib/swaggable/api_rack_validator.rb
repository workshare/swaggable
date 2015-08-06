module Swaggable
  class ApiRackValidator
    attr_accessor(
      :definition,
      :request,
    )

    def initialize opts = {}
      @definition, @request = opts.values_at(:definition, :request)
    end

    def errors_for_request
      endpoint_validator.errors_for_request request
    end

    def errors_for_response response
      endpoint_validator.errors_for_response response
    end

    def endpoint
      definition.endpoints.detect do |e|
        e.match? request['REQUEST_METHOD'], request['PATH_INFO']
      end
    end

    def endpoint_validator
      @endpoint_validator ||= EndpointRackValidator.new(endpoint: endpoint)
    end
  end
end

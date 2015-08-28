module Swaggable
  class ApiValidator
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
        e.match? *request_signature
      end || raise_endpoint_not_found
    end

    def endpoint_validator
      @endpoint_validator ||= EndpointValidator.new(endpoint: endpoint)
    end

    private

    def raise_endpoint_not_found
      raise Errors::EndpointNotFound.new(
        "No endpoint matched #{request_signature.join(" ")}"
      )
    end

    def request_signature
      [request['REQUEST_METHOD'], request['PATH_INFO']]
    end
  end
end

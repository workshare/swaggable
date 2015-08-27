module Swaggable
  class EndpointValidator
    attr_accessor(
      :endpoint,
    )

    def initialize(args)
      @endpoint = args.fetch(:endpoint)
    end

    def errors_for_request request
      Errors::ValidationsCollection.new.tap do |errors|
        errors.merge! content_type_errors_for_request(request)
        errors.merge! CheckMandatoryParameters.(endpoint: endpoint, request: request)
        errors.merge! CheckExpectedParameters.(endpoint: endpoint, request: request)
        errors.merge! CheckBodySchema.(body_definition: endpoint.body, request: request) if endpoint.body
      end
    end

    def errors_for_response response
      raise NotImplementedError.new()
    end

    private

    def content_type_errors_for_request request
      RequestContentTypeValidator.new(content_types: endpoint.consumes).
        errors_for_request request
    end
  end
end

module Swaggable
  class EndpointRackValidator
    attr_accessor(
      :endpoint,
    )

    def initialize(args)
      @endpoint = args.fetch(:endpoint)
    end

    def errors_for_request request
      Errors::ValidationsCollection.new.tap do |errors|
        errors.merge! content_type_errors_for_request(request)
        errors.merge! CheckMandatoryRackParameters.(endpoint: endpoint, request: request)
        errors.merge! CheckBodySchema.(body_definition: body_schema, request: request) if body_schema
      end
    end

    def errors_for_response response
      raise NotImplementedError.new()
    end

    private

    def content_type_errors_for_request request
      RequestContentTypeRackValidator.new(content_types: endpoint.consumes).
        errors_for_request request
    end

    def body_schema
      endpoint.parameters.detect {|e| e.location :body }
    end
  end
end

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
        errors.merge! CheckRequestContentType.(endpoint: endpoint, request: request)
        errors.merge! CheckMandatoryParameters.(endpoint: endpoint, request: request)
        errors.merge! CheckExpectedParameters.(endpoint: endpoint, request: request)
        errors.merge! CheckBodySchema.(endpoint: endpoint, request: request)
      end
    end

    def errors_for_response response
      raise NotImplementedError.new()
    end
  end
end

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
  end
end

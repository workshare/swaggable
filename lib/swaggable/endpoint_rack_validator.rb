module Swaggable
  class EndpointRackValidator
    attr_accessor(
      :endpoint,
    )

    def initialize(args)
      @endpoint = args.fetch(:endpoint)
    end

    def errors_for_request request
      []
    end

    def errors_for_response response
      raise NotImplementedError.new()
    end
  end
end

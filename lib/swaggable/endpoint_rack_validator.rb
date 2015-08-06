module Swaggable
  class EndpointRackValidator
    attr_accessor(
      :endpoint,
    )

    def initialize(endpoint:)
      @endpoint = endpoint
    end

    def errors_for_request request
      raise NotImplementedError.new()
    end

    def errors_for_response response
      raise NotImplementedError.new()
    end
  end
end

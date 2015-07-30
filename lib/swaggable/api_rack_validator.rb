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
      []
    end

    def errors_for_response resp
      []
    end

    private

    def endpoint
      definition.endpoints.detect do |e|
        e.match? request['REQUEST_METHOD'], request['PATH_INFO']
      end
    end
  end
end

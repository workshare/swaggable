module Swaggable
  class ValidatingRackApp
    attr_accessor(
      :app,
      :definition,
    )

    def initialize args = {}
      @app = args[:app]
      @definition = args[:definition]
    end

    def call req
      req = RackRequestAdapter.new req

      validator = ApiValidator.new definition: definition, request: req

      errors = validator.errors_for_request
      raise(errors) if errors.any?

      rack_resp = app.call req
      resp = RackResponseAdapter.new rack_resp

      errors = validator.errors_for_response resp
      raise(errors) if errors.any?

      rack_resp
    end
  end
end

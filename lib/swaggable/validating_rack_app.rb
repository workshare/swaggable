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
      validator = ApiRackValidator.new definition: definition, request: req

      errors = validator.errors_for_request
      raise(errors) if errors.any?

      resp = app.call req

      # errors = validator.errors_for_response resp
      raise(errors) if errors.any?

      resp
    end
  end
end

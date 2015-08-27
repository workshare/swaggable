module Swaggable
  class CheckExpectedParameters
    attr_reader :endpoint, :request

    def initialize args
      @endpoint = args.fetch(:endpoint)
      @request = args.fetch(:request)
    end

    def self.call(*args)
      new(*args).send :errors
    end

    private

    def errors
      Errors::ValidationsCollection.new.tap do |errors|
        request.parameters(endpoint).each do |parameter|
          unless endpoint.parameters.include? parameter
            errors << Errors::Validation.new("Unexpected parameter #{parameter.inspect}")
          end
        end
      end
    end
  end
end

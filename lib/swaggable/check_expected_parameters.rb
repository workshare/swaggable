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
        errors_for_expected_parameters_in_query.each {|e| errors << e }
      end
    end

    private

    def errors_for_expected_parameters_in_query
      endpoint_p = endpoint.parameters.select {|p| p.location == :query }
      request_p = request.query_parameters

      errors_for_expected_parameters endpoint_p, request_p
    end

    def errors_for_expected_parameters endpoint_p, request_p
      [].tap do |errors|
        request_p.each do |name, value|
          unless endpoint_p.detect{|p| p.name == name }
            errors << Errors::Validation.new("Unexpected parameter #{name.inspect}")
          end
        end
      end
    end
  end
end

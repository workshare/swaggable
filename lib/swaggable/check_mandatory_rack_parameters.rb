module Swaggable
  class CheckMandatoryRackParameters
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
        errors_for_required_parameters_in_query.each {|e| errors << e }
        errors_for_required_parameters_in_path.each {|e| errors << e }
        errors_for_required_parameters_in_undefined_location.each {|e| errors << e }
      end
    end

    private

    def errors_for_required_parameters_in_path
      endpoint_p = endpoint.parameters.select {|p| p.location == :path }
      request_p = endpoint.path_parameters_for request.path

      errors_for_required_parameters endpoint_p, request_p
    end

    def errors_for_required_parameters_in_query
      endpoint_p = endpoint.parameters.select {|p| p.location == :query }
      request_p = request.query_parameters

      errors_for_required_parameters endpoint_p, request_p
    end

    def errors_for_required_parameters_in_undefined_location
      endpoint_p = endpoint.parameters.select {|p| p.location == nil }
      request_p = endpoint.path_parameters_for(request.path).
        merge(request.query_parameters)

      errors_for_required_parameters endpoint_p, request_p
    end

    def errors_for_required_parameters endpoint_p, request_p
      [].tap do |errors|
        endpoint_p.select(&:required?).each do |param|
          unless request_p.keys.include? param.name
            errors << Errors::Validation.new("Missing parameter #{param.inspect}")
          end
        end
      end
    end
  end
end
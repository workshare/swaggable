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
        endpoint_query_parameters.select(&:required?).each do |param|
          unless request_query_parameters.keys.include? param.name
            errors << Errors::Validation.new("Missing param #{param.inspect}")
          end
        end

        endpoint_path_parameters.select(&:required?).each do |param|
          unless request_path_parameters.keys.include? param.name
            errors << Errors::Validation.new("Missing param #{param.inspect}")
          end
        end

        endpoint_no_location_parameters.select(&:required?).each do |param|
          unless all_request_parameters.keys.include? param.name
            errors << Errors::Validation.new("Missing param #{param.inspect}")
          end
        end
      end
    end

    private

    def endpoint_parameters
      endpoint.parameters
    end

    def endpoint_query_parameters
      endpoint_parameters.select {|p| p.location == :query }
    end

    def endpoint_path_parameters
      endpoint_parameters.select {|p| p.location == :path }
    end

    def endpoint_no_location_parameters
      endpoint_parameters.select {|p| p.location == nil }
    end

    def request_query_parameters
      request.query_parameters
    end

    def request_path_parameters
      endpoint.path_parameters_for request.path
    end

    def all_request_parameters
      request_query_parameters.
        merge(request_path_parameters)
    end
  end
end

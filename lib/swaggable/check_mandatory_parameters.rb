module Swaggable
  class CheckMandatoryParameters
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
        endpoint.parameters.select(&:required).each do |parameter|
          unless request.parameters(endpoint).include? parameter
            errors << Errors::Validation.new("Missing parameter #{parameter.inspect}")
          end
        end
      end
    end
  end
end

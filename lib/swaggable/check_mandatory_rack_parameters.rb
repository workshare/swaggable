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
        parameters.select(&:required?).each do |param|
          unless request.parameters.keys.include? param.name
            errors << Errors::Validation.new("Missing param #{param.inspect}")
          end
        end
      end
    end

    def parameters
      endpoint.parameters
    end
  end
end

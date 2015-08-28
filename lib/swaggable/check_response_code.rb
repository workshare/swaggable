module Swaggable
  class CheckResponseCode
    attr_reader :endpoint, :response

    def initialize args
      @endpoint = args.fetch(:endpoint)
      @response = args.fetch(:response)
    end

    def self.call(*args)
      new(*args).send :errors
    end

    private

    def errors
      Errors::ValidationsCollection.new.tap do |errors|
        unless endpoint.responses[response.code]
          errors << Errors::Validation.new("Status code #{response.code.inspect} not supported")
        end
      end
    end
  end
end

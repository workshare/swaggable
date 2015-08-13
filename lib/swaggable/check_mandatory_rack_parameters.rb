module Swaggable
  class CheckMandatoryRackParameters
    attr_reader :parameters, :request

    def initialize args
      @parameters = args.fetch(:parameters)
      @request = args.fetch(:request)
    end

    def self.call(*args)
      new(*args).send :errors
    end

    private

    def errors
      Errors::ValidationsCollection.new.tap do |errors|
        parameters.select(&:required?).each do |param|
          unless request.params.keys.include? param.name
            errors << Errors::Validation.new("Missing param #{param.inspect}")
          end
        end
      end
    end
  end
end

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
      []
    end
  end
end

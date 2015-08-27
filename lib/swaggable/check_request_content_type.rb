module Swaggable
  class CheckRequestContentType
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
        type = request.content_type

        unless type.nil? || endpoint.consumes.include?(type)
          errors << Errors::UnsupportedContentType.new("Content-Type #{type} not supported")
        end
      end
    end
  end
end

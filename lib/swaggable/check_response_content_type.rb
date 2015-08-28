module Swaggable
  class CheckResponseContentType
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
        type = response.content_type

        unless type.nil? || endpoint.produces.include?(type)
          errors << Errors::UnsupportedContentType.new("Content-Type #{type} not supported")
        end
      end
    end
  end
end

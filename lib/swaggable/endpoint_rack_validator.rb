module Swaggable
  class EndpointRackValidator
    attr_accessor(
      :endpoint,
    )

    def initialize(args)
      @endpoint = args.fetch(:endpoint)
    end

    def errors_for_request request
      [].tap do |errors|
        content_type_errors_for_request(request).each {|e| errors << e }
      end
    end

    def errors_for_response response
      raise NotImplementedError.new()
    end

    private

    def content_type_errors_for_request request
      [].tap do |errors|
        content_type = request['CONTENT_TYPE']

        if valid_content_type? content_type
          errors << "#{content_type} is not supported: #{endpoint.consumes.inspect}"
        end
      end
    end

    def valid_content_type? content_type
      !endpoint.consumes.include?(content_type) if content_type
    end
  end
end

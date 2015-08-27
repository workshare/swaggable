module Swaggable
  class RequestContentTypeValidator
    attr_accessor :content_types

    def initialize opts
      @content_types = opts.fetch(:content_types)
    end

    def errors_for_request request
      Errors::ValidationsCollection.new.tap do |errors|
        type = request['CONTENT_TYPE']

        unless type.nil? || content_types.include?(type)
          errors << Errors::UnsupportedContentType.new("Content-Type #{type} not supported")
        end
      end
    end
  end
end

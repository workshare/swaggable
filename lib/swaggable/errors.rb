module Swaggable
  module Errors
    autoload :ValidationsCollection, 'swaggable/errors/validations_collection'

    Validation = Class.new StandardError
    EndpointNotFound = Class.new StandardError
    UnsupportedContentType = Class.new Validation
  end
end

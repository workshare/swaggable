module Swaggable
  module Errors
    autoload :ValidationsCollection, 'swaggable/errors/validations_collection'

    Validation = Class.new StandardError
  end
end

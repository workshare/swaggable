require 'forwarding_dsl'

module Swaggable
  class ResponseDefinition
    include DefinitionBase

    getsetter :status
    getsetter :description
  end
end


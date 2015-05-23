require 'json'

module  Swaggable
  class RackApp
    attr_accessor(
      :api_definition,
      :serializer,
    )

    def initialize args = {}
      args.each {|k,v| send "#{k}=", v }
    end

    def call env
      [
        200,
        {'Content-Type' => 'application/json'},
        [serializer.serialize(api_definition).to_json]
      ]
    end

    def serializer
      @serializer ||= Swagger2Serializer.new
    end
  end
end

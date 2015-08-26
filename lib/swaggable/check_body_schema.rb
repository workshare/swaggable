module Swaggable
  class CheckBodySchema
    attr_reader :body_definition, :request

    def initialize args
      @body_definition = args.fetch(:body_definition)
      @request = args.fetch(:request)
    end

    def self.call(*args)
      new(*args).send :errors
    end

    private

    def errors
      Errors::ValidationsCollection.new.tap do |errors|
        errors_for_required_parameters_in_body.each {|e| errors << e }
      end
    end

    private

    def errors_for_required_parameters_in_body
      if body_definition == nil
        []
      elsif !body_definition.required?
        []
      elsif !request.body
        [Errors::Validation.new("Missing body")]
      elsif body_definition.schema.empty?
        []
      else
        missing_attribute_errors + unexpected_attribute_errors
      end
    end

    def missing_attribute_errors
      [].tap do |errors|
        schema.attributes.select(&:required?).each do |attr|
          unless body.has_key? attr.name
            errors << Errors::Validation.new("Missing body parameter #{attr.inspect}")
          end
        end
      end
    end

    def unexpected_attribute_errors
      [].tap do |errors|
        body.each do |key, value|
          unless schema.attributes[key]
            errors << Errors::Validation.new("Unexpected body parameter #{key.inspect}")
          end
        end
      end
    end

    def schema
      body_definition.schema
    end

    def body
      request.parsed_body
    end
  end
end

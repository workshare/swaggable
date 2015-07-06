require 'forwarding_dsl'

module Swaggable
  module EnumerableAttributes
    def self.included klass
      klass.include ForwardingDsl::Getsetter
      klass.extend ClassMethods
    end

    module ClassMethods
      def attr_enum name, choices
        getsetter name

        class_variable_set :"@@valid_#{name}_list", choices

        define_method "#{name}=" do |value|
          valid_values = self.class.class_variable_get :"@@valid_#{name}_list"

          unless valid_values.include? value
            raise ArgumentError.new("#{value.inspect} is not one a valid #{name}: #{valid_values.map(&:inspect).join(", ")}")
          end

          instance_variable_set(:"@#{name}", value)
        end
      end
    end
  end
end


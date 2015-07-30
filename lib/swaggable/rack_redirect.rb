module Swaggable
  class RackRedirect
    attr_accessor(
      :to, 
      :from, 
      :next_app,
    )

    def initialize(first_arg, second_arg = nil)
      if second_arg
        next_app = first_arg
        options = second_arg.dup
      else
        next_app = nil
        options = first_arg.dup
      end

      @next_app = next_app
      @from = options.delete(:from)
      @to = options.delete(:to) || raise(ArgumentError.new(":to option is mandatory"))

      if options.any?
        raise ArgumentError.new "Unsupported options #{options.keys.inspect}"
      end
    end

    def call env
      if from.nil?
       redirect
      elsif from.is_a?(String) && env['PATH_INFO'] == from
        redirect
      elsif from.is_a?(Regexp) && env['PATH_INFO'] =~ from
        redirect
      elsif next_app.nil?
        raise('No application defined to forward the request to')
      else
        next_app.call env
      end
    end

    private

    def redirect
      [301, {'Location' => to}, []]
    end
  end
end

module Swaggable
  class MimeTypeDefinition
    def initialize id
      @type, @subtype, @options = case id
                                  when String then parse_string id
                                  when Symbol then parse_symbol id
                                  else raise "#{id.inspect} not valid"
                                  end
    end

    def name
      "#{type}/#{subtype}"
    end

    alias to_s name

    def http_string
      http = name
      http += options if options
      http
    end

    def to_sym
      string = if type == 'application'
                 subtype
               else
                 name
               end

      string.gsub(/[-\.\/]+/,'_').to_sym
    end

    def inspect
      "#<Swaggable::ContentTypeDefinition: #{type}/#{subtype}>"
    end

    def == other
      case other
      when self.class then name == other.name
      when String, Symbol then name == self.class.new(other).name
      else false
      end
    end

    alias eql? ==

    def hash
      name.hash
    end

    private

    attr_reader :type, :subtype, :options

    def parse_string id
      type, subtype, options = id.match(/(?<type>[^\/]+)\/?(?<subtype>[^;]*)(?<options>.*)/).captures

      type = nil if type == ""
      subtype = nil if subtype == ""
      options = nil if options == ""

      [type, subtype, options]
    end

    def parse_symbol id
      type = 'application'
      subtype = id.to_s.gsub('_','-')
      options = nil

      [type, subtype, options]
    end
  end
end

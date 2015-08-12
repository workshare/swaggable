module Swaggable
  class MimeTypeDefinition
    attr_reader :type, :subtype

    def initialize id
      @type, @subtype = case id
                        when String then id.split('/')
                        when Symbol then ["application", id.to_s.gsub('_','-')]
                        else raise "#{id.inspect} not valid"
                        end
    end

    def name
      "#{type}/#{subtype}"
    end

    alias http_string name # parameters are not supported yet

    alias to_s name

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
  end
end

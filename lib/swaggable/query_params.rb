module Swaggable
  class QueryParams < Delegator
    def initialize arg = nil
      case arg
      when String then self.string = arg
      when Hash then self.hash = arg
      when NilClass then self.hash = {}
      else raise("#{arg.inspect} not supported. Use Hash or String")
      end
    end

    def __getobj__
      string && hash
    end

    def string
      @string
    end

    def hash
      parse(string).freeze
    end

    def string= value
      @string = value
    end

    def hash= value
      self.string = serialize(value)
    end

    def []= key, value
      self.hash= hash.merge(key => value)
    end

    private

    def serialize hash
      hash.map{|k, v| "#{CGI.escape k.to_s}=#{CGI.escape v.to_s}" }.join("&")
    end

    def parse string
      CGI.parse(string).inject({}){|a,h| k,v = h; a[k]=v.first; a} 
    end

    def binding
      ::Kernel.binding
    end
  end
end

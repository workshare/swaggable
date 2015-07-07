module Swaggable
  class AttributeDefinition
    include DefinitionBase

    getsetter :name

    attr_enum :type, [
      :integer,
      :long,
      :float,
      :double,
      :string,
      :byte,
      :boolean,
      :date,
      :date_time,
      :password,
    ]

    def json_type
      json_type_hash.fetch(type)
    end

    def json_format
      json_format_hash.fetch(type)
    end

    private

    def json_type_hash
      {
        integer: :integer,
        long: :integer,
        float: :number,
        double: :number,
        string: :string,
        byte: :string,
        boolean: :boolean,
        date: :string,
        date_time: :string,
        password: :string,
      }
    end

    def json_format_hash
      {
        integer: :int32,
        long: :int64,
        float: :float,
        double: :double,
        string: nil,
        byte: :byte,
        boolean: nil,
        date: :date,
        date_time: :"date-time",
        password: :password,
      }
    end
  end
end

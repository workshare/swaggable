module Swaggable
  class SchemaDefinition
    include DefinitionBase

    getsetter :name

    def attributes &block
      ForwardingDsl.run(
        @attributes ||= build_attributes,
        &block
      )
    end

    def empty?
      attributes.empty?
    end

    private

    def build_attributes
      MiniObject::IndexedList.new.tap do |l|
        l.build { AttributeDefinition.new }
        l.key {|e| e.name }
      end
    end
  end
end

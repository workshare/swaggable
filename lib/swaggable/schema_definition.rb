module Swaggable
  class SchemaDefinition

    def attributes &block
      ForwardingDsl.run(
        @attributes ||= build_attributes,
        &block
      )
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

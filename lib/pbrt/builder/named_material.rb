module PBRT
  class Builder
    class NamedMaterial
      def initialize(builder, name)
        @builder = builder
        @name = name
      end

      def method_missing(method, *args)
        Material.new(self).public_send(method, *args)
      end

      def write(statement)
        @builder.write(modified(statement))
      end

      private

      def modified(statement)
        statement.to_s.sub("Material", %(MakeNamedMaterial "#@name" "string type"))
      end
    end
  end
end

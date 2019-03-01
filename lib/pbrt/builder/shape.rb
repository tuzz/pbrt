module PBRT
  class Builder
    class Shape
      def initialize(builder)
        @builder = builder
      end

      def sphere(params = {})
        write Statement.variadic("Shape", "sphere", ParameterList.from(
          params,

          radius: :float,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end
    end
  end
end

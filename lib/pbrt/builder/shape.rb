module PBRT
  class Builder
    class Shape
      def initialize(builder)
        @builder = builder
      end

      def sphere(params = {})
        @builder.write Statement.variadic("Shape", "sphere", ParameterList.from(
          params,

          radius: :float,
        ))
      end
    end
  end
end

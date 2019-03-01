module PBRT
  class Builder
    class PixelFilter
      def initialize(builder)
        @builder = builder
      end

      def box(params = {})
        write Statement.variadic("PixelFilter", "box", ParameterList.from(
          params,

          xwidth: :float,
          ywidth: :float,
        ))
      end

      def gaussian(params = {})
        write Statement.variadic("PixelFilter", "gaussian", ParameterList.from(
          params,

          xwidth: :float,
          ywidth: :float,
          alpha: :float,
        ))
      end

      def mitchell(params = {})
        write Statement.variadic("PixelFilter", "mitchell", ParameterList.from(
          params,

          xwidth: :float,
          ywidth: :float,
          B: :float,
          C: :float,
        ))
      end

      def sinc(params = {})
        write Statement.variadic("PixelFilter", "sinc", ParameterList.from(
          params,

          xwidth: :float,
          ywidth: :float,
          tau: :float,
        ))
      end

      def triangle(params = {})
        write Statement.variadic("PixelFilter", "triangle", ParameterList.from(
          params,

          xwidth: :float,
          ywidth: :float,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end
    end
  end
end

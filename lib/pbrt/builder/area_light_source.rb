module PBRT
  class Builder
    class AreaLightSource
      def initialize(builder)
        @builder = builder
      end

      def diffuse(params = {})
        write Statement.variadic("AreaLightSource", "diffuse", ParameterList.from(
          params,

          L: :spectrum,
          twosided: :bool,
          samples: :integer,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end
    end
  end
end

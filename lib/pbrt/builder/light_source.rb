module PBRT
  class Builder
    class LightSource
      def initialize(builder)
        @builder = builder
      end

      def distant(params = {})
        write Statement.variadic("LightSource", "distant", ParameterList.from(
          params,

          scale: :spectrum,
          L: :spectrum,
          from: :point3,
          to: :point3,
        ))
      end

      def goniometric(params = {})
        write Statement.variadic("LightSource", "goniometric", ParameterList.from(
          params,

          scale: :spectrum,
          I: :spectrum,
          mapname: :string,
        ))
      end

      def infinite(params = {})
        write Statement.variadic("LightSource", "infinite", ParameterList.from(
          params,

          scale: :spectrum,
          L: :spectrum,
          samples: :integer,
          mapname: :string,
        ))
      end

      def point(params = {})
        write Statement.variadic("LightSource", "point", ParameterList.from(
          params,

          scale: :spectrum,
          I: :spectrum,
          from: :point3,
        ))
      end

      def projection(params = {})
        write Statement.variadic("LightSource", "projection", ParameterList.from(
          params,

          scale: :spectrum,
          I: :spectrum,
          fov: :float,
          mapname: :string,
        ))
      end

      def spot(params = {})
        write Statement.variadic("LightSource", "spot", ParameterList.from(
          params,

          scale: :spectrum,
          I: :spectrum,
          from: :point3,
          to: :point3,
          coneangle: :float,
          conedeltaangle: :float,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end
    end
  end
end

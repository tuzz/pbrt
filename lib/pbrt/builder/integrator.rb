module PBRT
  class Builder
    class Integrator
      def initialize(builder)
        @builder = builder
      end

      def bdpt(params = {})
        write Statement.variadic("Integrator", "bdpt", ParameterList.from(
          params,

          maxdepth: :integer,
          pixelbounds: :integer,
          lightsamplestrategy: :string,
          visualizestrategies: :bool,
          visualizeweights: :bool,
        ))
      end

      def directlighting(params = {})
        write Statement.variadic("Integrator", "directlighting", ParameterList.from(
          params,

          strategy: :string,
          maxdepth: :integer,
          pixelbounds: :integer,
        ))
      end

      def mlt(params = {})
        write Statement.variadic("Integrator", "mlt", ParameterList.from(
          params,

          maxdepth: :integer,
          bootstrapsamples: :integer,
          chains: :integer,
          mutationsperpixel: :integer,
          largestepprobability: :float,
          sigma: :float,
        ))
      end

      def path(params = {})
        write Statement.variadic("Integrator", "path", ParameterList.from(
          params,

          maxdepth: :integer,
          pixelbounds: :integer,
          rrthreshold: :float,
          lightsamplestrategy: :string,
        ))
      end

      def sppm(params = {})
        write Statement.variadic("Integrator", "sppm", ParameterList.from(
          params,

          maxdepth: :integer,
          iterations: :integer,
          photonsperiteration: :integer,
          imagewritefrequency: :integer,
          radius: :float,
        ))
      end

      def whitted(params = {})
        write Statement.variadic("Integrator", "whitted", ParameterList.from(
          params,

          maxdepth: :integer,
          pixelbounds: :integer,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end
    end
  end
end

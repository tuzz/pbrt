module PBRT
  class Builder
    class Sampler
      def initialize(builder)
        @builder = builder
      end

      def o2sequence(params = {})
        write Statement.variadic("Sampler", "02sequence", ParameterList.from(
          params,
          pixelsamples: :integer,
        ))
      end

      def halton(params = {})
        write Statement.variadic("Sampler", "halton", ParameterList.from(
          params,
          pixelsamples: :integer,
        ))
      end

      def maxmindist(params = {})
        write Statement.variadic("Sampler", "maxmindist", ParameterList.from(
          params,
          pixelsamples: :integer,
        ))
      end

      def random(params = {})
        write Statement.variadic("Sampler", "random", ParameterList.from(
          params,
          pixelsamples: :integer,
        ))
      end

      def sobol(params = {})
        write Statement.variadic("Sampler", "sobol", ParameterList.from(
          params,
          pixelsamples: :integer,
        ))
      end

      def stratified(params = {})
        write Statement.variadic("Sampler", "stratified", ParameterList.from(
          params,

          jitter: :bool,
          xsamples: :integer,
          ysamples: :integer,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end
    end
  end
end

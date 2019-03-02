module PBRT
  class Builder
    class NamedMedium
      def initialize(builder, name)
        @builder = builder
        @directive = %(MakeNamedMedium "#{name}" "string type")
      end

      def homogeneous(params = {})
        write Statement.variadic(@directive, "homogeneous", ParameterList.from(
          params,

          sigma_a: :spectrum,
          sigma_s: :spectrum,
          preset: :string,
          g: :float,
          scale: :float,
        ))
      end

      def heterogeneous(params = {})
        write Statement.variadic(@directive, "heterogeneous", ParameterList.from(
          params,

          sigma_a: :spectrum,
          sigma_s: :spectrum,
          preset: :string,
          g: :float,
          scale: :float,
          p0: :point3,
          p1: :point3,
          nx: :integer,
          ny: :integer,
          nz: :integer,
          density: :float,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end
    end
  end
end

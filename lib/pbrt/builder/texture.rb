module PBRT
  class Builder
    class Texture
      def initialize(builder, name, type)
        @builder = builder
        @directive = %(Texture "#{name}" "#{type}")
      end

      def bilerp(params = {})
        write Statement.variadic(@directive, "bilerp", ParameterList.from(
          params,

          mapping: :string,
          uscale: :float,
          vscale: :float,
          udelta: :float,
          vdelta: :float,
          v1: :vector3,
          v2: :vector3,
          v00: :texture,
          v01: :texture,
          v10: :texture,
          v11: :texture,
        ))
      end

      def checkerboard(params = {})
        write Statement.variadic(@directive, "checkerboard", ParameterList.from(
          params,

          mapping: :string,
          uscale: :float,
          vscale: :float,
          udelta: :float,
          vdelta: :float,
          v1: :vector3,
          v2: :vector3,
          dimension: :integer,
          tex1: :texture,
          tex2: :texture,
          aamode: :string,
        ))
      end

      def constant(params = {})
        write Statement.variadic(@directive, "constant", ParameterList.from(
          params,

          value: :texture,
          foo: :texture,
        ))
      end

      def dots(params = {})
        write Statement.variadic(@directive, "dots", ParameterList.from(
          params,

          mapping: :string,
          uscale: :float,
          vscale: :float,
          udelta: :float,
          vdelta: :float,
          v1: :vector3,
          v2: :vector3,
          inside: :texture,
          outside: :texture,
        ))
      end

      def fbm(params = {})
        write Statement.variadic(@directive, "fbm", ParameterList.from(
          params,

          octaves: :integer,
          roughness: :float,
        ))
      end

      def imagemap(params = {})
        write Statement.variadic(@directive, "imagemap", ParameterList.from(
          params,

          mapping: :string,
          uscale: :float,
          vscale: :float,
          udelta: :float,
          vdelta: :float,
          v1: :vector3,
          v2: :vector3,
          filename: :string,
          wrap: :string,
          maxanisotropy: :float,
          trilinear: :bool,
          scale: :float,
          gamma: :bool,
        ))
      end

      def marble(params = {})
        write Statement.variadic(@directive, "marble", ParameterList.from(
          params,

          octaves: :integer,
          roughness: :float,
          scale: :float,
          variation: :float,
        ))
      end

      def mix(params = {})
        write Statement.variadic(@directive, "mix", ParameterList.from(
          params,

          tex1: :texture,
          tex2: :texture,
          amount: :float_texture,
        ))
      end

      def scale(params = {})
        write Statement.variadic(@directive, "scale", ParameterList.from(
          params,

          tex1: :texture,
          tex2: :texture,
        ))
      end

      def uv(params = {})
        write Statement.variadic(@directive, "uv", ParameterList.from(
          params,

          mapping: :string,
          uscale: :float,
          vscale: :float,
          udelta: :float,
          vdelta: :float,
          v1: :vector3,
          v2: :vector3,
        ))
      end

      def windy(params = {})
        write Statement.variadic(@directive, "windy", ParameterList.from(
          params,

          mapping: :string,
        ))
      end

      def wrinkled(params = {})
        write Statement.variadic(@directive, "wrinkled", ParameterList.from(
          params,

          octaves: :integer,
          roughness: :float,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end
    end
  end
end

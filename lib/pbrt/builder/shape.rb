module PBRT
  class Builder
    class Shape
      def initialize(builder)
        @builder = builder
      end

      def cone(params = {})
        write Statement.variadic("Shape", "cone", ParameterList.from(
          params,

          allow_material_overrides: true,
          radius: :float,
          height: :float,
          phimax: :float,
        ))
      end

      def curve(params = {})
        write Statement.variadic("Shape", "curve", ParameterList.from(
          params,

          allow_material_overrides: true,
          P: :point3,
          basis: :string,
          degree: :integer,
          type: :string,
          N: :normal3,
          width: :float,
          width0: :float,
          width1: :float,
          splitdepth: :integer,
        ))
      end

      def cylinder(params = {})
        write Statement.variadic("Shape", "cylinder", ParameterList.from(
          params,

          allow_material_overrides: true,
          radius: :float,
          zmin: :float,
          zmax: :float,
          phimax: :float,
        ))
      end

      def disk(params = {})
        write Statement.variadic("Shape", "disk", ParameterList.from(
          params,

          allow_material_overrides: true,
          height: :float,
          radius: :float,
          innerradius: :float,
          phimax: :float,
        ))
      end

      def hyperboloid(params = {})
        write Statement.variadic("Shape", "hyperboloid", ParameterList.from(
          params,

          allow_material_overrides: true,
          p1: :point3,
          p2: :point3,
          phimax: :float,
        ))
      end

      def paraboloid(params = {})
        write Statement.variadic("Shape", "paraboloid", ParameterList.from(
          params,

          allow_material_overrides: true,
          radius: :float,
          zmin: :float,
          zmax: :float,
          phimax: :float,
        ))
      end

      def sphere(params = {})
        write Statement.variadic("Shape", "sphere", ParameterList.from(
          params,

          allow_material_overrides: true,
          radius: :float,
          zmin: :float,
          zmax: :float,
          phimax: :float,
        ))
      end

      def trianglemesh(params = {})
        write Statement.variadic("Shape", "trianglemesh", ParameterList.from(
          params,

          allow_material_overrides: true,
          indices: :integer,
          P: :point3,
          N: :normal3,
          S: :vector3,
          uv: :float,
          alpha: :float_texture,
          shadowalpha: :float_texture,
          st: :float,
        ))
      end

      def heightfield(params = {})
        write Statement.variadic("Shape", "heightfield", ParameterList.from(
          params,

          allow_material_overrides: true,
          nu: :integer,
          nv: :integer,
          Pz: :float,
        ))
      end

      def loopsubdiv(params = {})
        write Statement.variadic("Shape", "loopsubdiv", ParameterList.from(
          params,

          allow_material_overrides: true,
          levels: :integer,
          indices: :integer,
          P: :point3,
        ))
      end

      def nurbs(params = {})
        write Statement.variadic("Shape", "nurbs", ParameterList.from(
          params,

          allow_material_overrides: true,
          nu: :integer,
          nv: :integer,
          uorder: :integer,
          vorder: :integer,
          uknots: :float,
          vknots: :float,
          u0: :float,
          v0: :float,
          u1: :float,
          v1: :float,
          P: :point3,
          Pw: :float,
        ))
      end

      def plymesh(params = {})
        write Statement.variadic("Shape", "plymesh", ParameterList.from(
          params,

          allow_material_overrides: true,
          filename: :string,
          alpha: :float_texture,
          shadowalpha: :float_texture,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end
    end
  end
end

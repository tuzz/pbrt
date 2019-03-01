module PBRT
  class Builder
    class Camera
      def initialize(builder)
        @builder = builder
      end

      def environment(params = {})
        write Statement.variadic("Camera", "environment", ParameterList.from(
          params,

          shutteropen: :float,
          shutterclose: :float,
          frameaspectratio: :float,
          screenwindow: :float,
        ))
      end

      def orthographic(params = {})
        write Statement.variadic("Camera", "orthographic", ParameterList.from(
          params,

          shutteropen: :float,
          shutterclose: :float,
          frameaspectratio: :float,
          screenwindow: :float,
          lensradius: :float,
          focaldistance: :float,
        ))
      end

      def perspective(params = {})
        write Statement.variadic("Camera", "perspective", ParameterList.from(
          params,

          shutteropen: :float,
          shutterclose: :float,
          frameaspectratio: :float,
          screenwindow: :float,
          lensradius: :float,
          focaldistance: :float,
          fov: :float,
          halffov: :float,
        ))
      end

      def realistic(params = {})
        write Statement.variadic("Camera", "realistic", ParameterList.from(
          params,

          shutteropen: :float,
          shutterclose: :float,
          lensfile: :string,
          aperturediameter: :float,
          focusdistance: :float,
          simpleweighting: :bool,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end
    end
  end
end

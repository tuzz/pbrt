module PBRT
  class Builder
    class Material
      def initialize(builder)
        @builder = builder
      end

      def disney(params = {})
        write Statement.variadic("Material", "disney", ParameterList.from(
          params,

          bumpmap: :float_texture,
          color: :spectrum_texture,
          anisotropic: :float_texture,
          clearcoat: :float_texture,
          clearcoatgloss: :float_texture,
          eta: :float_texture,
          metallic: :float_texture,
          roughness: :float_texture,
          scatterdistance: :spectrum_texture,
          sheen: :float_texture,
          sheentint: :float_texture,
          spectrans: :float_texture,
          speculartint: :float_texture,
          thin: :bool,
          difftrans: :spectrum_texture,
          flatness: :spectrum_texture,
        ))
      end

      def fourier(params = {})
        write Statement.variadic("Material", "fourier", ParameterList.from(
          params,

          bumpmap: :float_texture,
          bsdffile: :string,
        ))
      end

      def glass(params = {})
        write Statement.variadic("Material", "glass", ParameterList.from(
          params,

          bumpmap: :float_texture,
          Kr: :spectrum_texture,
          Kt: :spectrum_texture,
          eta: :float_texture,
          uroughness: :float_texture,
          vroughness: :float_texture,
          remaproughness: :bool,
        ))
      end

      def hair(params = {})
        write Statement.variadic("Material", "hair", ParameterList.from(
          params,

          bumpmap: :float_texture,
          sigma_a: :spectrum_texture,
          color: :spectrum_texture,
          eumelanin: :float_texture,
          pheomelanin: :float_texture,
          eta: :float_texture,
          beta_m: :float_texture,
          beta_n: :float_texture,
          alpha: :float_texture,
        ))
      end

      def kdsubsurface(params = {})
        write Statement.variadic("Material", "kdsubsurface", ParameterList.from(
          params,

          bumpmap: :float_texture,
          Kd: :spectrum_texture,
          mfp: :float_texture,
          eta: :float_texture,
          Kr: :spectrum_texture,
          Kt: :spectrum_texture,
          uroughness: :float_texture,
          vroughness: :float_texture,
          remaproughness: :bool,
        ))
      end

      def matte(params = {})
        write Statement.variadic("Material", "matte", ParameterList.from(
          params,

          bumpmap: :float_texture,
          Kd: :spectrum_texture,
          sigma: :float_texture,
        ))
      end

      def metal(params = {})
        write Statement.variadic("Material", "metal", ParameterList.from(
          params,

          bumpmap: :float_texture,
          eta: :spectrum_texture,
          k: :spectrum_texture,
          roughness: :float_texture,
          uroughness: :float_texture,
          vroughness: :float_texture,
          remaproughness: :bool,
        ))
      end

      def mirror(params = {})
        write Statement.variadic("Material", "mirror", ParameterList.from(
          params,

          bumpmap: :float_texture,
          Kr: :spectrum_texture,
        ))
      end

      def mix(params = {})
        write Statement.variadic("Material", "mix", ParameterList.from(
          params,

          bumpmap: :float_texture,
          amount: :spectrum_texture,
          namedmaterial1: :string,
          namedmaterial2: :string,
        ))
      end

      def none(params = {})
        write Statement.variadic("Material", "none", ParameterList.from(
          params,
          bumpmap: :float_texture,
        ))
      end

      def plastic(params = {})
        write Statement.variadic("Material", "plastic", ParameterList.from(
          params,

          bumpmap: :float_texture,
          Kd: :spectrum_texture,
          Ks: :spectrum_texture,
          roughness: :float_texture,
          remaproughness: :bool,
        ))
      end

      def substrate(params = {})
        write Statement.variadic("Material", "substrate", ParameterList.from(
          params,

          bumpmap: :float_texture,
          Kd: :spectrum_texture,
          Ks: :spectrum_texture,
          uroughness: :float_texture,
          vroughness: :float_texture,
          remaproughness: :bool,
        ))
      end

      def subsurface(params = {})
        write Statement.variadic("Material", "subsurface", ParameterList.from(
          params,

          bumpmap: :float_texture,
          name: :string,
          sigma_a: :spectrum_texture,
          sigma_prime_s: :spectrum_texture,
          scale: :float,
          eta: :float_texture,
          Kr: :spectrum_texture,
          Kt: :spectrum_texture,
          uroughness: :float_texture,
          vroughness: :float_texture,
          remaproughness: :bool,
        ))
      end

      def translucent(params = {})
        write Statement.variadic("Material", "translucent", ParameterList.from(
          params,

          bumpmap: :float_texture,
          Kd: :spectrum_texture,
          Ks: :spectrum_texture,
          reflect: :spectrum_texture,
          transmit: :spectrum_texture,
          roughness: :float_texture,
          remaproughness: :bool,
        ))
      end

      def uber(params = {})
        write Statement.variadic("Material", "uber", ParameterList.from(
          params,

          bumpmap: :float_texture,
          Kd: :spectrum_texture,
          Ks: :spectrum_texture,
          Kr: :spectrum_texture,
          Kt: :spectrum_texture,
          roughness: :float_texture,
          uroughness: :float_texture,
          vroughness: :float_texture,
          eta: :float_texture,
          opacity: :spectrum_texture,
          remaproughness: :bool,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end

      ALL_PARAMS = {
          Kd: :spectrum_texture,
          Kr: :spectrum_texture,
          Ks: :spectrum_texture,
          Kt: :spectrum_texture,
          alpha: :float_texture,
          amount: :spectrum_texture,
          anisotropic: :float_texture,
          beta_m: :float_texture,
          beta_n: :float_texture,
          bsdffile: :string,
          bumpmap: :float_texture,
          clearcoat: :float_texture,
          clearcoatgloss: :float_texture,
          color: :spectrum_texture,
          difftrans: :spectrum_texture,
          eumelanin: :float_texture,
          flatness: :spectrum_texture,
          k: :spectrum_texture,
          metallic: :float_texture,
          mfp: :float_texture,
          name: :string,
          namedmaterial1: :string,
          namedmaterial2: :string,
          opacity: :spectrum_texture,
          pheomelanin: :float_texture,
          reflect: :spectrum_texture,
          remaproughness: :bool,
          roughness: :float_texture,
          scale: :float,
          scatterdistance: :spectrum_texture,
          sheen: :float_texture,
          sheentint: :float_texture,
          sigma: :float_texture,
          sigma_a: :spectrum_texture,
          sigma_prime_s: :spectrum_texture,
          spectrans: :float_texture,
          speculartint: :float_texture,
          thin: :bool,
          transmit: :spectrum_texture,
          uroughness: :float_texture,
          vroughness: :float_texture,

          # eta appears as both a float_texture and spectrum_texture
          eta: :texture,
      }.freeze
    end
  end
end

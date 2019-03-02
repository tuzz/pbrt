# This class does double duty as both a means of wrapping parameter
# values to disambiguate them from floats/spectrums, but it's also
# the interface for the builder to write Texture directives.

module PBRT
  class Texture
    attr_reader :args

    def initialize(builder, *args)
      @builder = builder
      @args = args
    end

    # If these three methods are called, it means the user is trying
    # to write a Texture directive, so delegate to that builder.
    def spectrum
      PBRT::Builder::Texture.new(@builder, args.first, "spectrum")
    end

    def color
      PBRT::Builder::Texture.new(@builder, args.first, "color")
    end

    def float
      PBRT::Builder::Texture.new(@builder, args.first, "float")
    end

    def self.unpack(type, value)
      return [type, value] unless type.to_s.include?("texture")
      return [:texture, value.args] if value.is_a?(self)

      if type == :float_texture
        return string?(value) ? [:texture, value] : [:float, value]
      end

      if type == :spectrum_texture && !string?(value)
        return [:spectrum, value]
      end

      if type == :texture && !string?(value)
        return [:float, value]
      end

      raise_ambiguous_error(value)
    end

    def self.raise_ambiguous_error(value)
      message = "Please specify whether #{value.inspect} is a spectrum or texture.\n"
      message += "If it's a texture, wrap it with: texture(#{value.inspect})\n"
      message += "If it's a spectrum, wrap it with a representation: rgb(#{value.inspect})\n"
      message += "Valid representations are: rgb, xyz, sampled and blackbody"

      raise AmbiguousArgumentError, message
    end

    def self.string?(*value)
      value.flatten.first.is_a?(String)
    end
  end

  class AmbiguousArgumentError < StandardError
  end
end

module PBRT
  class Texture
    attr_reader :args

    def initialize(*args)
      @args = args
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

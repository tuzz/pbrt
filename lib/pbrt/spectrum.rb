module PBRT
  class Spectrum
    attr_reader :type, :args

    def initialize(type, *args)
      @type = type
      @args = args
    end

    def self.unpack(value)
      check_value_is_a_spectrum(value)

      [value.type, value.args]
    end

    def self.check_value_is_a_spectrum(value)
      return if value.is_a?(self)

      message = "Please specify the spectrum representation for #{value.inspect}.\n"
      message += "You can do this by wrapping the value: rgb(#{value.inspect})\n"
      message += "Valid representations are: rgb, xyz, sampled and blackbody"

      raise AmbiguousSpectrumError, message
    end
  end

  class AmbiguousSpectrumError < StandardError
  end
end

module PBRT
  class ParameterList
    def self.from(params, type_signature)
      Signature.new(type_signature).check(params)

      pairs = params.map do |name, value|
        type = type_signature[name]
        type, value = Spectrum.unpack(value) if type == :spectrum

        [Parameter.new(type, name), Values.new(value)]
      end

      new(pairs.to_h)
    end

    def initialize(name_value_pairs)
      @name_value_pairs = name_value_pairs
    end

    def to_s
      @name_value_pairs.map do |parameter, values|
        [parameter.to_s, "[#{values}]"].join(" ")
      end.join(" ")
    end
  end
end

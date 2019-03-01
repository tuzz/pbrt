module PBRT
  class ParameterList
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

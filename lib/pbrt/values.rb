module PBRT
  class Values
    def initialize(*inner)
      @inner = inner
    end

    def to_s
      formatted = @inner.map { |v| format(v) }

      "[#{formatted.join(" ")}]"
    end

    def format(value)
      return '"true"' if value.is_a?(TrueClass)
      return '"false"' if value.is_a?(FalseClass)
      return %("#{value}") if value.is_a?(String)

      value
    end
  end
end

module PBRT
  class Values
    def initialize(*inner)
      @inner = inner.flatten
    end

    def to_s
      @inner.map { |v| format(v) }.join(" ")
    end

    def size
      @inner.size
    end

    private

    def format(value)
      return '"true"' if value.is_a?(TrueClass)
      return '"false"' if value.is_a?(FalseClass)
      return %("#{value}") if value.is_a?(String)

      value
    end
  end
end

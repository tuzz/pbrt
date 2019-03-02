module PBRT
  class Signature
    TYPES = %i(
      integer float point2 vector2 point3
      vector3 normal3 spectrum bool string
      texture float_texture spectrum_texture
    )

    def initialize(names_and_types)
      @names_and_types = names_and_types

      check_for_known_types
    end

    def check(params)
      check_for_surplus(params)
    end

    private

    def check_for_known_types
      unknown = @names_and_types.values - TYPES

      if unknown.any?
        raise ArgumentError, "unknown types: #{unknown.join(", ")}"
      end
    end

    def check_for_surplus(params)
      surplus = params.keys - @names_and_types.keys

      if surplus.size == 1
        raise ArgumentError, "(unknown keyword: #{surplus.first})"
      elsif surplus.size > 1
        raise ArgumentError, "(unknown keywords: #{surplus.join(", ")})"
      end
    end
  end
end

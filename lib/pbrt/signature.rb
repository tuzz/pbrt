module PBRT
  class Signature
    def initialize(*parameter_names)
      @parameter_names = parameter_names
    end

    def check(params)
      surplus = params.keys - @parameter_names

      if surplus.size == 1
        raise ArgumentError, "(unknown keyword: #{surplus.first})"
      elsif surplus.size > 1
        raise ArgumentError, "(unknown keywords: #{surplus.join(", ")})"
      end
    end
  end
end

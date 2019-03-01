module PBRT
  class Builder
    class Shape
      def initialize(io)
        @io = io
      end

      def sphere(radius: nil)
        @io.puts Statement.variadic("Shape", "sphere", ParameterList.from(
          params,

          radius: :float,
        ))
      end
    end
  end
end

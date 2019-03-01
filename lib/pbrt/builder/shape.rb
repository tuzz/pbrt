module PBRT
  class Builder
    class Shape
      def initialize(io)
        @io = io
      end

      def sphere(radius: nil)
        parameter_list = ParameterList.new(
          Parameter.new(:float, :radius) => Values.new(radius),
        )

        @io.puts Statement.variadic("Shape", "sphere", parameter_list)
      end
    end
  end
end

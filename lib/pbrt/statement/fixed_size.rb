module PBRT
  class Statement
    class FixedSize
      def initialize(directive, expected, *args)
        @directive = directive
        @expected = expected
        @values = Values.new(*args)

        check_size
      end

      def to_s
        @values.size.zero? ? @directive : "#@directive #@values"
      end

      private

      def check_size
        return if @expected == @values.size

        message = "wrong number of arguments to #@directive "
        message += "(given #{@values.size}, expected #@expected)"

        raise ArgumentError, message
      end
    end
  end
end

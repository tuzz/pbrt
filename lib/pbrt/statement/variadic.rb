module PBRT
  class Statement
    class Variadic
      def initialize(directive, kind, parameter_list)
        @directive = directive
        @kind = kind
        @parameter_list = parameter_list
      end

      def to_s
        %(#@directive "#@kind" #@parameter_list)
      end
    end
  end
end

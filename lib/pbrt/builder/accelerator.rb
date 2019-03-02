module PBRT
  class Builder
    class Accelerator
      def initialize(builder)
        @builder = builder
      end

      def bvh(params = {})
        write Statement.variadic("Accelerator", "bvh", ParameterList.from(
          params,

          maxnodeprims: :integer,
          splitmethod: :string,
        ))
      end

      def kdtree(params = {})
        write Statement.variadic("Accelerator", "kdtree", ParameterList.from(
          params,

          intersectcost: :integer,
          traversalcost: :integer,
          emptybonus: :float,
          maxprims: :integer,
          maxdepth: :integer,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end
    end
  end
end

module PBRT
  class Builder
    class Film
      def initialize(builder)
        @builder = builder
      end

      def image(params = {})
        write Statement.variadic("Film", "image", ParameterList.from(
          params,

          xresolution: :integer,
          yresolution: :integer,
          cropwindow: :float,
          scale: :float,
          maxsampleluminance: :float,
          diagonal: :float,
          filename: :string,
        ))
      end

      private

      def write(statement)
        @builder.write(statement)
      end
    end
  end
end

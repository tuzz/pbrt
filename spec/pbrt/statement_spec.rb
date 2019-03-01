module PBRT
  RSpec.describe Statement do
    describe ".fixed_size" do
      it "errors if the number of values does not match the size" do
        expect { described_class.fixed_size("Translate", 3, Values.new(1, 2)) }
          .to raise_error(ArgumentError, "wrong number of arguments to Translate (given 2, expected 3)")
      end

      it "does not error if the correct number of values are in sub-arrays" do
        expect { described_class.fixed_size("Translate", 3, Values.new([1, 2, 3])) }
          .not_to raise_error
      end

      describe "#to_s" do
        it "concatenates the directive with its values" do
          subject = described_class.fixed_size("Translate", 3, Values.new(1, 2, 3))
          expect(subject.to_s).to eq("Translate 1 2 3")

          subject = described_class.fixed_size("WorldBegin", 0)
          expect(subject.to_s).to eq("WorldBegin")
        end
      end
    end

    describe ".variadic" do
      describe "#to_s" do
        it "concatenates the directive with the kind (in quotes) and the parameter list" do
          parameter_list = ParameterList.new(
            Parameter.new(:string, "filename") => Values.new("simple.png"),
            Parameter.new(:integer, "xresolution") => Values.new(800),
          )

          subject = described_class.variadic("Film", "image", parameter_list)
          expect(subject.to_s).to eq(<<~PBRT.strip)
            Film "image" "string filename" ["simple.png"] "integer xresolution" [800]
          PBRT
        end
      end
    end
  end
end

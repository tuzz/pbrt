module PBRT
  RSpec.describe ParameterList do
    describe ".from" do
      it "constructs a parameter list from the params" do
        subject = described_class.from(
          { foo: 1, bar: 2 },

          foo: :float,
          bar: :integer,
        )

        expect(subject.to_s).to eq(<<~PBRT.strip)
          "float foo" [1] "integer bar" [2]
        PBRT
      end

      it "errors if there are params not in the signature" do
        expect { described_class.from({ foo: 1 }, bar: :integer) }
          .to raise_error(ArgumentError, "(unknown keyword: foo)")
      end
    end

    describe "#to_s" do
      it "concatenates the pairs and encloses values in square brackets" do
        subject = described_class.new(
          Parameter.new(:string, "filename") => Values.new("simple.png"),
          Parameter.new(:integer, "xresolution") => Values.new(800),
        )

        expect(subject.to_s).to eq(<<~PBRT.strip)
          "string filename" ["simple.png"] "integer xresolution" [800]
        PBRT
      end
    end
  end
end

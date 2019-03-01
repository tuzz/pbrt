module PBRT
  RSpec.describe ParameterList do
    describe "#to_s" do
      it "concatenates the parameter-value pairs" do
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

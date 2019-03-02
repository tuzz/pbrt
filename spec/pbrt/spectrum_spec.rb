module PBRT
  RSpec.describe Spectrum do
    describe ".unpack" do
      it "unpacks the spectrum's type and value" do
        subject = described_class.new(:rgb, 0.1, 0.2, 0.3)
        type, value = described_class.unpack(subject)

        expect(type).to eq(:rgb)
        expect(value).to eq [0.1, 0.2, 0.3]
      end

      it "errors if the value is not a spectrum" do
        expect { described_class.unpack([1, 2, 3]) }
          .to raise_error(AmbiguousSpectrumError, /Please specify the spectrum/)
      end
    end
  end
end

module PBRT
  RSpec.describe Texture do
    describe ".unpack" do
      it "unpacks the texture's type and value" do
        subject = described_class.new("foo")
        type, value = described_class.unpack(:texture, subject)

        expect(type).to eq(:texture)
        expect(value).to eq ["foo"]
      end

      context "when the value is not a string" do
        it "coerces float_textures into floats" do
          type, value = described_class.unpack(:float_texture, 1)

          expect(type).to eq(:float)
          expect(value).to eq(1)
        end

        it "coerces spectrum_textures into spectrums" do
          type, value = described_class.unpack(:spectrum_texture, 1)

          expect(type).to eq(:spectrum)
          expect(value).to eq(1)
        end

        # We could ask the user to specify whether it's a spectrum or a float,
        # but I think floats are more common and this is more convenient.
        it "coerces textures into floats" do
          type, value = described_class.unpack(:texture, 1)

          expect(type).to eq(:float)
          expect(value).to eq(1)
        end
      end

      context "when the value is a string" do
        it "coerces float_textures into textures" do
          type, value = described_class.unpack(:float_texture, "foo")

          expect(type).to eq(:texture)
          expect(value).to eq("foo")
        end

        it "does not coerce spectrum_textures and raises an error" do
          expect { described_class.unpack(:spectrum_texture, "foo") }
            .to raise_error(AmbiguousArgumentError, /Please specify/)
        end

        it "does not coerce textures and raises an error" do
          expect { described_class.unpack(:texture, "foo") }
            .to raise_error(AmbiguousArgumentError, /Please specify/)
        end
      end
    end
  end
end

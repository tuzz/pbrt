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

      context "when the type is a spectrum" do
        it "sets the type from the value's representation" do
          subject = described_class.from(
            { foo: Spectrum.new(:rgb, 0.1, 0.2, 0.3) },
            foo: :spectrum,
          )

          expect(subject.to_s).to eq('"rgb foo" [0.1 0.2 0.3]')
        end
      end

      context "when the type is a float_texture" do
        it "sets the type to texture if the value is wrapped" do
          subject = described_class.from({ foo: Texture.new(nil, "name") }, foo: :float_texture)
          expect(subject.to_s).to eq('"texture foo" ["name"]')
        end

        it "sets the type from the value's representation" do
          subject = described_class.from({ foo: "name" }, foo: :float_texture)
          expect(subject.to_s).to eq('"texture foo" ["name"]')

          subject = described_class.from({ foo: 1 }, foo: :float_texture)
          expect(subject.to_s).to eq('"float foo" [1]')
        end
      end

      context "when the type is a spectrum_texture" do
        it "sets the type to texture if the value is wrapped" do
          subject = described_class.from({ foo: Texture.new(nil, "name") }, foo: :spectrum_texture)
          expect(subject.to_s).to eq('"texture foo" ["name"]')
        end

        it "raises an error if the spectrum representation is ambiguous" do
          expect { described_class.from({ foo: 1 }, foo: :spectrum_texture) }
            .to raise_error(AmbiguousSpectrumError)
        end

        it "raises an error if the type is ambiguous" do
          expect { described_class.from({ foo: "name" }, foo: :spectrum_texture) }
            .to raise_error(AmbiguousArgumentError)
        end
      end

      context "when the type is a texture" do
        it "sets the type to texture if the value is wrapped" do
          subject = described_class.from({ foo: Texture.new(nil, "name") }, foo: :texture)
          expect(subject.to_s).to eq('"texture foo" ["name"]')
        end

        it "coerces non-string types to floats as these are more common" do
          subject = described_class.from({ foo: 1 }, foo: :texture)
          expect(subject.to_s).to eq('"float foo" [1]')
        end

        it "raises an error for string types" do
          expect { described_class.from({ foo: "name" }, foo: :texture) }
            .to raise_error(AmbiguousArgumentError)
        end
      end

      context "when 'allow_material_overrides' is set" do
        it "allows material parameters to be set" do
          subject = described_class.from({ sheen: 1 }, allow_material_overrides: true)
          expect(subject.to_s).to eq('"float sheen" [1]')
        end
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

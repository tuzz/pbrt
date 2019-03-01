module PBRT
  RSpec.describe Statement do
    describe ".fixed_size" do
      it "raises an error if the number of values does not match the size" do
        expect { described_class.fixed_size("Translate", 3, Values.new(1, 2)) }
          .to raise_error(ArgumentError, "wrong number of arguments to Translate (given 2, expected 3)")
      end

      describe "#to_s" do
        it "concatenates the directive with its values" do
          subject = described_class.fixed_size("Translate", 3, Values.new(1, 2, 3))
          expect(subject.to_s).to eq("Translate 1 2 3")
        end
      end
    end

    describe ".variadic" do
      # TODO
    end
  end
end

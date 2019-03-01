RSpec.describe PBRT::Values do
  describe "#to_s" do
    it "separates values with spaces" do
      subject = described_class.new(1, 2, 3)
      expect(subject.to_s).to eq("1 2 3")
    end

    it "encloses strings in quotes" do
      subject = described_class.new("foo", "bar")
      expect(subject.to_s).to eq('"foo" "bar"')
    end

    it "encloses booleans in quotes" do
      subject = described_class.new(true, false)
      expect(subject.to_s).to eq('"true" "false"')
    end

    it "flattens values that have been grouped into sub-arrays" do
      subject = described_class.new([1, 2, 3], [4, 5, 6], [7, 8, 9])
      expect(subject.to_s).to eq("1 2 3 4 5 6 7 8 9")
    end
  end
end

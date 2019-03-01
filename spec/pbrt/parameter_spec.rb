RSpec.describe PBRT::Parameter do
  describe "#to_s" do
    it "encloses the parameter's type and its name in a string" do
      subject = described_class.new(:vector2, :foo)
      expect(subject.to_s).to eq('"vector2 foo"')
    end
  end
end

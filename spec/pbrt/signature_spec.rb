RSpec.describe PBRT::Signature do
  it "errors if there are params not in the signature" do
    subject = described_class.new(:foo, :bar)

    expect { subject.check(bar: 1, baz: 2) }
      .to raise_error(ArgumentError, "(unknown keyword: baz)")

    expect { subject.check(bar: 1, baz: 2, qux: 3) }
      .to raise_error(ArgumentError, "(unknown keywords: baz, qux)")
  end
end

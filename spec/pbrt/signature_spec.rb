RSpec.describe PBRT::Signature do
  it "errors if there are params not in the signature" do
    subject = described_class.new(foo: :integer, bar: :integer)

    expect { subject.check(bar: 1, baz: 2) }
      .to raise_error(ArgumentError, "(unknown keyword: baz)")

    expect { subject.check(bar: 1, baz: 2, qux: 3) }
      .to raise_error(ArgumentError, "(unknown keywords: baz, qux)")
  end

  it "errors if a type isn't known" do
    expect { described_class.new(foo: :bar) }
      .to raise_error(ArgumentError, "unknown types: bar")

    # vector is a short-hand for vector3, but I'd rather be explicit
    expect { described_class.new(foo: :vector) }
      .to raise_error(ArgumentError, "unknown types: vector")
  end

  # TODO: check the values are the right type
  # TODO: add support for point3[4]
  # TODO: add support for point3[n * m]
  # TODO: add support for point3[%3]
  # TODO: add support for point3*  (required)
end

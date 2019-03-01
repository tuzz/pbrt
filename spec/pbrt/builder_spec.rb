RSpec.describe PBRT::Builder do
  it "can build by explicit method calls" do
    subject = described_class.new

    subject.translate(1, 2, 3)
    subject.shape.sphere(radius: 1)

    expect(subject.to_s).to eq(<<~PBRT)
      Translate 1 2 3
      Shape "sphere" "float radius" [1]
    PBRT
  end

  it "can build by chaining method calls" do
    subject = described_class.new
      .translate(1, 2, 3)
      .shape.sphere(radius: 1)

    expect(subject.to_s).to eq(<<~PBRT)
      Translate 1 2 3
      Shape "sphere" "float radius" [1]
    PBRT
  end

  it "can build by providing a block" do
    subject = described_class.new do
      translate(1, 2, 3)
      shape.sphere(radius: 1)
    end

    expect(subject.to_s).to eq(<<~PBRT)
      Translate 1 2 3
      Shape "sphere" "float radius" [1]
    PBRT
  end

  it "can mix and match all of the above" do
    subject = described_class.new do
      translate(1, 2, 3)
    end.shape.sphere(radius: 1)

    subject.translate(4, 5, 6)

    expect(subject.to_s).to eq(<<~PBRT)
      Translate 1 2 3
      Shape "sphere" "float radius" [1]
      Translate 4 5 6
    PBRT
  end

  it "can be provided with an io object" do
    io = StringIO.new

    subject = described_class.new(io: io)
    subject.translate(1, 2, 3)

    expect(io.string).to eq("Translate 1 2 3\n")
  end
end

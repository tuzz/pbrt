RSpec.describe PBRT::Builder do
  def check(subject, *expected)
    expect(subject.to_s).to eq(expected.join(" ") + "\n")
  end

  describe "transformations" do
    # See: https://pbrt.org/fileformat-v3.html#transformations

    specify { check(subject.identity.to_s, "Identity") }
    specify { check(subject.translate(1, 2, 3), "Translate 1 2 3") }
    specify { check(subject.scale(1, 2, 3), "Scale 1 2 3") }
    specify { check(subject.rotate(1, 2, 3, 4), "Rotate 1 2 3 4") }
    specify { check(subject.look_at([1] * 9), "LookAt 1 1 1 1 1 1 1 1 1") }
    specify { check(subject.coordinate_system(1), "CoordinateSystem 1") }
    specify { check(subject.coord_sys_transform(1), "CoordSysTransform 1") }
    specify { check(subject.transform([1] * 16), "Transform 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1") }
    specify { check(subject.concat_transform([1] * 16), "ConcatTransform 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1") }
    specify { check(subject.transform_times(1, 2), "TransformTimes 1 2") }
    specify { check(subject.active_transform(:StartTime), "ActiveTransform StartTime") }
  end

  describe "cameras" do
    # See: https://pbrt.org/fileformat-v3.html#cameras

    specify do
      check(
        subject.camera.environment(
          shutteropen: 1,
          shutterclose: 2,
          frameaspectratio: 3,
          screenwindow: 4,
        ), [
          'Camera "environment"',
          '"float shutteropen" [1]',
          '"float shutterclose" [2]',
          '"float frameaspectratio" [3]',
          '"float screenwindow" [4]',
        ])
    end

    specify do
      check(
        subject.camera.orthographic(
          shutteropen: 1,
          shutterclose: 2,
          frameaspectratio: 3,
          screenwindow: 4,
          lensradius: 5,
          focaldistance: 6,
        ), [
          'Camera "orthographic"',
          '"float shutteropen" [1]',
          '"float shutterclose" [2]',
          '"float frameaspectratio" [3]',
          '"float screenwindow" [4]',
          '"float lensradius" [5]',
          '"float focaldistance" [6]',
        ])
    end

    specify do
      check(
        subject.camera.perspective(
          shutteropen: 1,
          shutterclose: 2,
          frameaspectratio: 3,
          screenwindow: 4,
          lensradius: 5,
          focaldistance: 6,
          fov: 7,
          halffov: 8,
        ), [
          'Camera "perspective"',
          '"float shutteropen" [1]',
          '"float shutterclose" [2]',
          '"float frameaspectratio" [3]',
          '"float screenwindow" [4]',
          '"float lensradius" [5]',
          '"float focaldistance" [6]',
          '"float fov" [7]',
          '"float halffov" [8]',
        ])
    end

    specify do
      check(
        subject.camera.realistic(
          shutteropen: 1,
          shutterclose: 2,
          lensfile: "foo",
          aperturediameter: 4,
          focusdistance: 5,
          simpleweighting: true,
        ), [
          'Camera "realistic"',
          '"float shutteropen" [1]',
          '"float shutterclose" [2]',
          '"string lensfile" ["foo"]',
          '"float aperturediameter" [4]',
          '"float focusdistance" [5]',
          '"bool simpleweighting" ["true"]',
        ])
    end
  end

  describe "ways to build" do
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
end

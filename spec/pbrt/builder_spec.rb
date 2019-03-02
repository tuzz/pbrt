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
          aperturediameter: 3,
          focusdistance: 4,
          simpleweighting: true,
        ), [
          'Camera "realistic"',
          '"float shutteropen" [1]',
          '"float shutterclose" [2]',
          '"string lensfile" ["foo"]',
          '"float aperturediameter" [3]',
          '"float focusdistance" [4]',
          '"bool simpleweighting" ["true"]',
        ])
    end
  end

  describe "samplers" do
    # See: https://pbrt.org/fileformat-v3.html#samplers

    specify do
      check(subject.sampler.o2sequence(pixelsamples: 1), [
        'Sampler "02sequence"',
        '"integer pixelsamples" [1]',
      ])
    end

    specify do
      check(subject.sampler.halton(pixelsamples: 1), [
        'Sampler "halton"',
        '"integer pixelsamples" [1]',
      ])
    end

    specify do
      check(subject.sampler.maxmindist(pixelsamples: 1), [
        'Sampler "maxmindist"',
        '"integer pixelsamples" [1]',
      ])
    end

    specify do
      check(subject.sampler.random(pixelsamples: 1), [
        'Sampler "random"',
        '"integer pixelsamples" [1]',
      ])
    end

    specify do
      check(subject.sampler.sobol(pixelsamples: 1), [
        'Sampler "sobol"',
        '"integer pixelsamples" [1]',
      ])
    end

    specify do
      check(subject.sampler.stratified(jitter: true, xsamples: 1, ysamples: 2), [
        'Sampler "stratified"',
        '"bool jitter" ["true"]',
        '"integer xsamples" [1]',
        '"integer ysamples" [2]',
      ])
    end
  end

  describe "film" do
    # See: https://pbrt.org/fileformat-v3.html#film

    specify do
      check(
        subject.film.image(
          xresolution: 1,
          yresolution: 2,
          cropwindow: [3, 4, 5, 6],
          scale: 7,
          maxsampleluminance: 8,
          diagonal: 9,
          filename: "foo",
        ), [
          'Film "image"',
          '"integer xresolution" [1]',
          '"integer yresolution" [2]',
          '"float cropwindow" [3 4 5 6]',
          '"float scale" [7]',
          '"float maxsampleluminance" [8]',
          '"float diagonal" [9]',
          '"string filename" ["foo"]',
        ])
    end
  end

  describe "filters" do
    # See: https://pbrt.org/fileformat-v3.html#filters

    specify do
      check(subject.pixel_filter.box(xwidth: 1, ywidth: 2), [
        'PixelFilter "box"',
        '"float xwidth" [1]',
        '"float ywidth" [2]',
      ])
    end

    specify do
      check(subject.pixel_filter.gaussian(xwidth: 1, ywidth: 2, alpha: 3), [
        'PixelFilter "gaussian"',
        '"float xwidth" [1]',
        '"float ywidth" [2]',
        '"float alpha" [3]',
      ])
    end

    specify do
      check(subject.pixel_filter.mitchell(xwidth: 1, ywidth: 2, B: 3, C: 4), [
        'PixelFilter "mitchell"',
        '"float xwidth" [1]',
        '"float ywidth" [2]',
        '"float B" [3]',
        '"float C" [4]',
      ])
    end

    specify do
      check(subject.pixel_filter.sinc(xwidth: 1, ywidth: 2, tau: 3), [
        'PixelFilter "sinc"',
        '"float xwidth" [1]',
        '"float ywidth" [2]',
        '"float tau" [3]',
      ])
    end

    specify do
      check(subject.pixel_filter.triangle(xwidth: 1, ywidth: 2), [
        'PixelFilter "triangle"',
        '"float xwidth" [1]',
        '"float ywidth" [2]',
      ])
    end
  end

  describe "integrators" do
    # See: https://pbrt.org/fileformat-v3.html#integrators

    specify do
      check(
        subject.integrator.bdpt(
          maxdepth: 1,
          pixelbounds: 2,
          lightsamplestrategy: "foo",
          visualizestrategies: true,
          visualizeweights: false,
        ), [
          'Integrator "bdpt"',
          '"integer maxdepth" [1]',
          '"integer pixelbounds" [2]',
          '"string lightsamplestrategy" ["foo"]',
          '"bool visualizestrategies" ["true"]',
          '"bool visualizeweights" ["false"]',
        ])
    end

    specify do
      check(
        subject.integrator.directlighting(
          strategy: "foo",
          maxdepth: 1,
          pixelbounds: 2,
        ), [
          'Integrator "directlighting"',
          '"string strategy" ["foo"]',
          '"integer maxdepth" [1]',
          '"integer pixelbounds" [2]',
        ])
    end

    specify do
      check(
        subject.integrator.mlt(
          maxdepth: 1,
          bootstrapsamples: 2,
          chains: 3,
          mutationsperpixel: 4,
          largestepprobability: 5,
          sigma: 6,
        ), [
          'Integrator "mlt"',
          '"integer maxdepth" [1]',
          '"integer bootstrapsamples" [2]',
          '"integer chains" [3]',
          '"integer mutationsperpixel" [4]',
          '"float largestepprobability" [5]',
          '"float sigma" [6]',
        ])
    end

    specify do
      check(
        subject.integrator.path(
          maxdepth: 1,
          pixelbounds: 2,
          rrthreshold: 3,
          lightsamplestrategy: "foo",
        ), [
          'Integrator "path"',
          '"integer maxdepth" [1]',
          '"integer pixelbounds" [2]',
          '"float rrthreshold" [3]',
          '"string lightsamplestrategy" ["foo"]',
        ])
    end

    specify do
      check(
        subject.integrator.sppm(
          maxdepth: 1,
          iterations: 2,
          photonsperiteration: 3,
          imagewritefrequency: 4,
          radius: 5,
        ), [
          'Integrator "sppm"',
          '"integer maxdepth" [1]',
          '"integer iterations" [2]',
          '"integer photonsperiteration" [3]',
          '"integer imagewritefrequency" [4]',
          '"float radius" [5]',
        ])
    end

    # At time of writing, the parameters for the WhittedIntegrator aren't listed.
    # https://github.com/mmp/pbrt-v3/blob/f7653953b2f9cc5d6a53b46acb5ce03317fd3e8b/src/integrators/whitted.cpp#L92-L94
    specify do
      check(
        subject.integrator.whitted(
          maxdepth: 1,
          pixelbounds: 2,
        ), [
          'Integrator "whitted"',
          '"integer maxdepth" [1]',
          '"integer pixelbounds" [2]',
        ])
    end
  end

  describe "accelerators" do
    # See: https://pbrt.org/fileformat-v3.html#accelerators

    specify do
      check(
        subject.accelerator.bvh(
          maxnodeprims: 1,
          splitmethod: "foo",
        ), [
          'Accelerator "bvh"',
          '"integer maxnodeprims" [1]',
          '"string splitmethod" ["foo"]',
        ])
    end

    specify do
      check(
        subject.accelerator.kdtree(
          intersectcost: 1,
          traversalcost: 2,
          emptybonus: 3,
          maxprims: 4,
          maxdepth: 5,
        ), [
          'Accelerator "kdtree"',
          '"integer intersectcost" [1]',
          '"integer traversalcost" [2]',
          '"float emptybonus" [3]',
          '"integer maxprims" [4]',
          '"integer maxdepth" [5]',
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

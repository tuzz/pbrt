RSpec.describe PBRT::Builder do
  def check(subject, *expected)
    expect(subject.to_s).to eq(expected.join(" ") + "\n")
  end

  describe "general structure" do
    # See: https://pbrt.org/fileformat-v3.html#general-structure

    specify do
      check(subject.world_begin { translate(1, 2, 3) }, <<~PBRT.strip)
        WorldBegin
        Translate 1 2 3
        WorldEnd
      PBRT
    end

    specify { check(subject.comment("foo bar"), "# foo bar") }
    specify { check(subject.comment("foo\nbar"), "# foo\n# bar") }
    specify { check(subject.include("foo/bar.pbrt"), 'Include "foo/bar.pbrt"') }
  end

  describe "spectrums" do
    # See: https://pbrt.org/fileformat-v3.html#parameter-lists

    specify do
      check(subject.light_source.infinite(L: subject.rgb(0.1, 0.2, 0.3)),
        'LightSource "infinite" "rgb L" [0.1 0.2 0.3]')
    end

    specify do
      check(subject.light_source.infinite(L: subject.xyz(0.1, 0.2, 0.3)),
        'LightSource "infinite" "xyz L" [0.1 0.2 0.3]')
    end

    specify do
      check(subject.light_source.infinite(L: subject.sampled(300, 0.3)),
        'LightSource "infinite" "spectrum L" [300 0.3]')
    end

    specify do
      check(subject.light_source.infinite(L: subject.sampled("filename")),
        'LightSource "infinite" "spectrum L" ["filename"]')
    end

    specify do
      check(subject.light_source.infinite(L: subject.blackbody(6500, 1)),
        'LightSource "infinite" "blackbody L" [6500 1]')
    end
  end

  describe "transformations" do
    # See: https://pbrt.org/fileformat-v3.html#transformations

    specify { check(subject.identity, "Identity") }
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

  describe "attributes" do
    # See: https://pbrt.org/fileformat-v3.html#attributes

    specify do
      check(subject.attribute_begin { translate(1, 2, 3) }, <<~PBRT.strip)
        AttributeBegin
        Translate 1 2 3
        AttributeEnd
      PBRT
    end

    specify do
      check(subject.transform_begin { translate(1, 2, 3) }, <<~PBRT.strip)
        TransformBegin
        Translate 1 2 3
        TransformEnd
      PBRT
    end

    specify { check(subject.reverse_orientation, "ReverseOrientation") }
  end

  describe "shapes" do
    # See: https://pbrt.org/fileformat-v3.html#shapes

    specify do
      check(
        subject.shape.cone(
          radius: 1,
          height: 2,
          phimax: 3,
        ), [
          'Shape "cone"',
          '"float radius" [1]',
          '"float height" [2]',
          '"float phimax" [3]',
        ])
    end

    specify do
      check(
        subject.shape.curve(
          P: [1] * 12,
          basis: ["foo"],
          degree: 2,
          type: ["bar"],
          N: [3] * 6,
          width: 4,
          width0: 5,
          width1: 6,
          splitdepth: 7,
        ), [
          'Shape "curve"',
          '"point3 P" [1 1 1 1 1 1 1 1 1 1 1 1]',
          '"string basis" ["foo"]',
          '"integer degree" [2]',
          '"string type" ["bar"]',
          '"normal3 N" [3 3 3 3 3 3]',
          '"float width" [4]',
          '"float width0" [5]',
          '"float width1" [6]',
          '"integer splitdepth" [7]',
        ])
    end

    specify do
      check(
        subject.shape.cylinder(
          radius: 1,
          zmin: 2,
          zmax: 3,
          phimax: 4,
        ), [
          'Shape "cylinder"',
          '"float radius" [1]',
          '"float zmin" [2]',
          '"float zmax" [3]',
          '"float phimax" [4]',
        ])
    end

    specify do
      check(
        subject.shape.disk(
          height: 1,
          radius: 2,
          innerradius: 3,
          phimax: 4,
        ), [
          'Shape "disk"',
          '"float height" [1]',
          '"float radius" [2]',
          '"float innerradius" [3]',
          '"float phimax" [4]',
        ])
    end

    specify do
      check(
        subject.shape.hyperboloid(
          p1: [1, 2, 3],
          p2: [4, 5, 6],
          phimax: 7,
        ), [
          'Shape "hyperboloid"',
          '"point3 p1" [1 2 3]',
          '"point3 p2" [4 5 6]',
          '"float phimax" [7]',
        ])
    end

    specify do
      check(
        subject.shape.paraboloid(
          radius: 1,
          zmin: 2,
          zmax: 3,
          phimax: 4,
        ), [
          'Shape "paraboloid"',
          '"float radius" [1]',
          '"float zmin" [2]',
          '"float zmax" [3]',
          '"float phimax" [4]',
        ])
    end

    specify do
      check(
        subject.shape.sphere(
          radius: 1,
          zmin: 2,
          zmax: 3,
          phimax: 4,
        ), [
          'Shape "sphere"',
          '"float radius" [1]',
          '"float zmin" [2]',
          '"float zmax" [3]',
          '"float phimax" [4]',
        ])
    end

    specify do
      check(
        subject.shape.trianglemesh(
          indices: [1, 2, 3],
          P: [4, 5, 6],
          N: [7, 8, 9],
          S: [10, 11, 12],
          uv: [13, 14],
          alpha: 15,
          shadowalpha: "foo",
        ), [
          'Shape "trianglemesh"',
          '"integer indices" [1 2 3]',
          '"point3 P" [4 5 6]',
          '"normal3 N" [7 8 9]',
          '"vector3 S" [10 11 12]',
          '"float uv" [13 14]',
          '"float alpha" [15]',
          '"texture shadowalpha" ["foo"]',
        ])
    end

    specify do
      check(
        subject.shape.heightfield(
          nu: 1,
          nv: 2,
          Pz: [3, 3],
        ), [
          'Shape "heightfield"',
          '"integer nu" [1]',
          '"integer nv" [2]',
          '"float Pz" [3 3]',
        ])
    end

    specify do
      check(
        subject.shape.loopsubdiv(
          levels: 1,
          indices: 2,
          P: [3, 4, 5],
        ), [
          'Shape "loopsubdiv"',
          '"integer levels" [1]',
          '"integer indices" [2]',
          '"point3 P" [3 4 5]',
        ])
    end

    specify do
      check(
        subject.shape.nurbs(
          nu: 1,
          nv: 2,
          uorder: 3,
          vorder: 4,
          uknots: [5, 6],
          vknots: [7, 8],
          u0: 9,
          v0: 10,
          u1: 11,
          v1: 12,
          P: [13, 14],
          Pw: [15, 16],
        ), [
          'Shape "nurbs"',
          '"integer nu" [1]',
          '"integer nv" [2]',
          '"integer uorder" [3]',
          '"integer vorder" [4]',
          '"float uknots" [5 6]',
          '"float vknots" [7 8]',
          '"float u0" [9]',
          '"float v0" [10]',
          '"float u1" [11]',
          '"float v1" [12]',
          '"point3 P" [13 14]',
          '"float Pw" [15 16]',
        ])
    end

    specify do
      check(
        subject.shape.plymesh(
          filename: "foo",
          alpha: "bar",
          shadowalpha: 1,
        ), [
          'Shape "plymesh"',
          '"string filename" ["foo"]',
          '"texture alpha" ["bar"]',
          '"float shadowalpha" [1]',
        ])
    end
  end

  describe "object instancing" do
    # See: https://pbrt.org/fileformat-v3.html#object-instancing

    specify do
      check(subject.object_begin("name") { translate(1, 2, 3) }, <<~PBRT.strip)
        ObjectBegin "name"
        Translate 1 2 3
        ObjectEnd
      PBRT
    end

    specify { check(subject.object_instance("name"), 'ObjectInstance "name"') }
  end

  describe "lights" do
    # See: https://pbrt.org/fileformat-v3.html#lights

    specify do
      check(
        subject.light_source.distant(
          scale: subject.rgb(1, 1, 1),
          L: subject.xyz(2, 2, 2),
          from: [3, 3, 3],
          to: [4, 4, 4],
        ), [
          'LightSource "distant"',
          '"rgb scale" [1 1 1]',
          '"xyz L" [2 2 2]',
          '"point3 from" [3 3 3]',
          '"point3 to" [4 4 4]',
        ])
    end

    specify do
      check(
        subject.light_source.goniometric(
          scale: subject.rgb(1, 1, 1),
          I: subject.xyz(2, 2, 2),
          mapname: "foo",
        ), [
          'LightSource "goniometric"',
          '"rgb scale" [1 1 1]',
          '"xyz I" [2 2 2]',
          '"string mapname" ["foo"]',
        ])
    end

    specify do
      check(
        subject.light_source.infinite(
          scale: subject.rgb(1, 1, 1),
          L: subject.xyz(2, 2, 2),
          samples: 3,
          mapname: "foo",
        ), [
          'LightSource "infinite"',
          '"rgb scale" [1 1 1]',
          '"xyz L" [2 2 2]',
          '"integer samples" [3]',
          '"string mapname" ["foo"]',
        ])
    end

    specify do
      check(
        subject.light_source.point(
          scale: subject.rgb(1, 1, 1),
          I: subject.xyz(2, 2, 2),
          from: [3, 3, 3],
        ), [
          'LightSource "point"',
          '"rgb scale" [1 1 1]',
          '"xyz I" [2 2 2]',
          '"point3 from" [3 3 3]',
        ])
    end

    specify do
      check(
        subject.light_source.projection(
          scale: subject.rgb(1, 1, 1),
          I: subject.xyz(2, 2, 2),
          fov: 3,
          mapname: "foo",
        ), [
          'LightSource "projection"',
          '"rgb scale" [1 1 1]',
          '"xyz I" [2 2 2]',
          '"float fov" [3]',
          '"string mapname" ["foo"]',
        ])
    end

    specify do
      check(
        subject.light_source.spot(
          scale: subject.rgb(1, 1, 1),
          I: subject.xyz(2, 2, 2),
          from: [3, 3, 3],
          to: [4, 4, 4],
          coneangle: 5,
          conedeltaangle: 6,
        ), [
          'LightSource "spot"',
          '"rgb scale" [1 1 1]',
          '"xyz I" [2 2 2]',
          '"point3 from" [3 3 3]',
          '"point3 to" [4 4 4]',
          '"float coneangle" [5]',
          '"float conedeltaangle" [6]',
        ])
    end
  end

  describe "area lights" do
    # See: https://pbrt.org/fileformat-v3.html#area-lights

    specify do
      check(
        subject.area_light_source.diffuse(
          L: subject.rgb(1, 1, 1),
          twosided: true,
          samples: 2,
        ), [
          'AreaLightSource "diffuse"',
          '"rgb L" [1 1 1]',
          '"bool twosided" ["true"]',
          '"integer samples" [2]',
        ])
    end
  end

  describe "materials" do
    # See: https://pbrt.org/fileformat-v3.html#materials

    specify { check(subject.named_material("foo"), 'NamedMaterial "foo"') }

    describe "#make_named_material" do
      it "uses the referenced material to determine the types" do
        check(
          subject.make_named_material(
            name: "myplastic",
            type: "plastic",
            bumpmap: "foo",
            Kd: subject.rgb(1, 1, 1),
            Ks: subject.sampled(2, 2, 2),
            roughness: 3,
            remaproughness: true,
          ), [
            'MakeNamedMaterial "myplastic"',
            '"string type" "plastic"',
            '"texture bumpmap" ["foo"]',
            '"rgb Kd" [1 1 1]',
            '"spectrum Ks" [2 2 2]',
            '"float roughness" [3]',
            '"bool remaproughness" ["true"]',
          ])
      end

      it "raises an error if a parameter isn't known" do
        expect {
          subject.make_named_material(
            name: "myplastic",
            type: "plastic",
            unknown: "foo",
          )
        }.to raise_error(ArgumentError, /unknown/)
      end

      it "raises an error if the material isn't known" do
        expect {
          subject.make_named_material(
            name: "myplastic",
            type: "copper",
            unknown: "foo",
          )
        }.to raise_error(NoMethodError, /copper/)
      end
    end

    specify do
      check(
        subject.material.disney(
          bumpmap: "foo",
          color: subject.rgb(1, 1, 1),
          anisotropic: 2,
          clearcoat: "bar",
          clearcoatgloss: 3,
          eta: 4,
          metallic: 5,
          roughness: 6,
          scatterdistance: subject.texture("baz"),
          sheen: 7,
          sheentint: 8,
          spectrans: 9,
          speculartint: 10,
          thin: true,
          difftrans: subject.xyz(1, 2, 3),
          flatness: subject.texture("qux"),
        ), [
          'Material "disney"',
          '"texture bumpmap" ["foo"]',
          '"rgb color" [1 1 1]',
          '"float anisotropic" [2]',
          '"texture clearcoat" ["bar"]',
          '"float clearcoatgloss" [3]',
          '"float eta" [4]',
          '"float metallic" [5]',
          '"float roughness" [6]',
          '"texture scatterdistance" ["baz"]',
          '"float sheen" [7]',
          '"float sheentint" [8]',
          '"float spectrans" [9]',
          '"float speculartint" [10]',
          '"bool thin" ["true"]',
          '"xyz difftrans" [1 2 3]',
          '"texture flatness" ["qux"]',
        ])
    end

    specify do
      check(
        subject.material.fourier(
          bumpmap: "foo",
          bsdffile: "bar",
        ), [
          'Material "fourier"',
          '"texture bumpmap" ["foo"]',
          '"string bsdffile" ["bar"]',
        ])
    end

    specify do
      check(
        subject.material.glass(
          bumpmap: "foo",
          Kr: subject.texture("bar"),
          Kt: subject.rgb(2, 2, 2),
          eta: 3,
          uroughness: "baz",
          vroughness: 4,
          remaproughness: true,
        ), [
          'Material "glass"',
          '"texture bumpmap" ["foo"]',
          '"texture Kr" ["bar"]',
          '"rgb Kt" [2 2 2]',
          '"float eta" [3]',
          '"texture uroughness" ["baz"]',
          '"float vroughness" [4]',
          '"bool remaproughness" ["true"]',
        ])
    end

    specify do
      check(
        subject.material.hair(
          bumpmap: "foo",
          sigma_a: subject.rgb(1, 1, 1),
          color: subject.texture("bar"),
          eumelanin: 2,
          pheomelanin: "baz",
          eta: 3,
          beta_m: 4,
          beta_n: 5,
          alpha: 6,
        ), [
          'Material "hair"',
          '"texture bumpmap" ["foo"]',
          '"rgb sigma_a" [1 1 1]',
          '"texture color" ["bar"]',
          '"float eumelanin" [2]',
          '"texture pheomelanin" ["baz"]',
          '"float eta" [3]',
          '"float beta_m" [4]',
          '"float beta_n" [5]',
          '"float alpha" [6]',
        ])
    end

    specify do
      check(
        subject.material.kdsubsurface(
          bumpmap: "foo",
          Kd: subject.rgb(1, 1, 1),
          mfp: 2,
          eta: 3,
          Kr: subject.texture("bar"),
          Kt: subject.xyz(4, 4, 4),
          uroughness: 5,
          vroughness: "baz",
          remaproughness: true,
        ), [
          'Material "kdsubsurface"',
          '"texture bumpmap" ["foo"]',
          '"rgb Kd" [1 1 1]',
          '"float mfp" [2]',
          '"float eta" [3]',
          '"texture Kr" ["bar"]',
          '"xyz Kt" [4 4 4]',
          '"float uroughness" [5]',
          '"texture vroughness" ["baz"]',
          '"bool remaproughness" ["true"]',
        ])
    end

    specify do
      check(
        subject.material.matte(
          bumpmap: "foo",
          Kd: subject.rgb(1, 1, 1),
          sigma: "bar",
        ), [
          'Material "matte"',
          '"texture bumpmap" ["foo"]',
          '"rgb Kd" [1 1 1]',
          '"texture sigma" ["bar"]',
        ])
    end

    specify do
      check(
        subject.material.metal(
          bumpmap: "foo",
          eta: subject.rgb(1, 1, 1),
          k: subject.blackbody(5000, 1),
          roughness: 2,
          uroughness: 3,
          vroughness: 4,
          remaproughness: true,
        ), [
          'Material "metal"',
          '"texture bumpmap" ["foo"]',
          '"rgb eta" [1 1 1]',
          '"blackbody k" [5000 1]',
          '"float roughness" [2]',
          '"float uroughness" [3]',
          '"float vroughness" [4]',
          '"bool remaproughness" ["true"]',
        ])
    end

    specify do
      check(
        subject.material.mirror(
          bumpmap: "foo",
          Kr: subject.texture("bar"),
        ), [
          'Material "mirror"',
          '"texture bumpmap" ["foo"]',
          '"texture Kr" ["bar"]',
        ])
    end

    specify do
      check(
        subject.material.mix(
          bumpmap: "foo",
          amount: subject.rgb(1, 1, 1),
          namedmaterial1: "bar",
          namedmaterial2: "baz",
        ), [
          'Material "mix"',
          '"texture bumpmap" ["foo"]',
          '"rgb amount" [1 1 1]',
          '"string namedmaterial1" ["bar"]',
          '"string namedmaterial2" ["baz"]',
        ])
    end

    specify do
      check(
        subject.material.none(
          bumpmap: "foo",
        ), [
          'Material "none"',
          '"texture bumpmap" ["foo"]',
        ])
    end

    specify do
      check(
        subject.material.plastic(
          bumpmap: "foo",
          Kd: subject.rgb(1, 1, 1),
          Ks: subject.sampled(2, 2, 2),
          roughness: 3,
          remaproughness: true,
        ), [
          'Material "plastic"',
          '"texture bumpmap" ["foo"]',
          '"rgb Kd" [1 1 1]',
          '"spectrum Ks" [2 2 2]',
          '"float roughness" [3]',
          '"bool remaproughness" ["true"]',
        ])
    end

    specify do
      check(
        subject.material.substrate(
          bumpmap: "foo",
          Kd: subject.rgb(1, 1, 1),
          Ks: subject.sampled(2, 2, 2),
          uroughness: 3,
          vroughness: "bar",
          remaproughness: true,
        ), [
          'Material "substrate"',
          '"texture bumpmap" ["foo"]',
          '"rgb Kd" [1 1 1]',
          '"spectrum Ks" [2 2 2]',
          '"float uroughness" [3]',
          '"texture vroughness" ["bar"]',
          '"bool remaproughness" ["true"]',
        ])
    end

    specify do
      check(
        subject.material.subsurface(
          bumpmap: "foo",
          name: "bar",
          sigma_a: subject.rgb(1, 1, 1),
          sigma_prime_s: subject.xyz(2, 2, 2),
          scale: 3,
          eta: 4,
          Kr: subject.texture("baz"),
          Kt: subject.blackbody(5000, 1),
          uroughness: 6,
          vroughness: 7,
          remaproughness: false,
        ), [
          'Material "subsurface"',
          '"texture bumpmap" ["foo"]',
          '"string name" ["bar"]',
          '"rgb sigma_a" [1 1 1]',
          '"xyz sigma_prime_s" [2 2 2]',
          '"float scale" [3]',
          '"float eta" [4]',
          '"texture Kr" ["baz"]',
          '"blackbody Kt" [5000 1]',
          '"float uroughness" [6]',
          '"float vroughness" [7]',
          '"bool remaproughness" ["false"]',
        ])
    end

    specify do
      check(
        subject.material.translucent(
          bumpmap: "foo",
          Kd: subject.texture("bar"),
          Ks: subject.rgb(1, 1, 1),
          reflect: subject.sampled(2, 2, 2),
          transmit: subject.texture("baz"),
          roughness: 3,
          remaproughness: true,
        ), [
          'Material "translucent"',
          '"texture bumpmap" ["foo"]',
          '"texture Kd" ["bar"]',
          '"rgb Ks" [1 1 1]',
          '"spectrum reflect" [2 2 2]',
          '"texture transmit" ["baz"]',
          '"float roughness" [3]',
          '"bool remaproughness" ["true"]',
        ])
    end

    specify do
      check(
        subject.material.uber(
          bumpmap: "foo",
          Kd: subject.rgb(1, 1, 1),
          Ks: subject.xyz(2, 2, 2),
          Kr: subject.texture("bar"),
          Kt: subject.blackbody(3000, 1),
          roughness: 4,
          uroughness: 5,
          vroughness: "baz",
          eta: 6,
          opacity: subject.sampled(7, 7, 7),
          remaproughness: false,
        ), [
          'Material "uber"',
          '"texture bumpmap" ["foo"]',
          '"rgb Kd" [1 1 1]',
          '"xyz Ks" [2 2 2]',
          '"texture Kr" ["bar"]',
          '"blackbody Kt" [3000 1]',
          '"float roughness" [4]',
          '"float uroughness" [5]',
          '"texture vroughness" ["baz"]',
          '"float eta" [6]',
          '"spectrum opacity" [7 7 7]',
          '"bool remaproughness" ["false"]',
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

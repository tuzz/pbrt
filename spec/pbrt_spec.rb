RSpec.describe PBRT do
  it "can generate the example pbrt file" do
    # From: https://pbrt.org/fileformat-v3.html#example

    builder = PBRT::Builder.new do
      look_at(3, 4, 1.5, 0.5, 0.5, 0, 0, 0, 1)
      camera.perspective(fov: 45)

      sampler.halton(pixelsamples: 128)
      integrator.path
      film.image(filename: "simple.png", xresolution: 400, yresolution: 400)

      world_begin do
        comment "uniform blue-ish illumination from all directions"
        light_source.infinite(L: rgb(0.4, 0.45, 0.5))

        comment "approximate the sun"
        light_source.distant(from: [-30, 40, 100], L: blackbody(3000, 1.5))

        attribute_begin do
          material.glass
          shape.sphere(radius: 1)
        end

        attribute_begin do
          texture("checks").spectrum.checkerboard(
            uscale: [8],
            vscale: [8],
            tex1: rgb(0.1, 0.1, 0.1),
            tex2: rgb(0.8, 0.8, 0.8),
          )

          material.matte(Kd: texture("checks"))
          translate(0, 0, -1)

          shape.trianglemesh(
            indices: [0, 1, 2, 0, 2, 3],
            P: [-20, -20, 0, 20, -20, 0, 20, 20, 0, -20, 20, 0],
            st: [0, 0, 1, 0, 1, 1, 0, 1],
          )
        end
      end
    end

    # This is a copy of the example, with a few minor cosmetic changes, e.g.
    # - one line per statement
    # - wrap some values in []
    # - point -> point3
    # - add leading 0 to floats

    expect(builder.to_s.lines).to eq(<<~PBRT.lines)
      LookAt 3 4 1.5 0.5 0.5 0 0 0 1
      Camera "perspective" "float fov" [45]
      Sampler "halton" "integer pixelsamples" [128]
      Integrator "path"
      Film "image" "string filename" ["simple.png"] "integer xresolution" [400] "integer yresolution" [400]
      WorldBegin
      # uniform blue-ish illumination from all directions
      LightSource "infinite" "rgb L" [0.4 0.45 0.5]
      # approximate the sun
      LightSource "distant" "point3 from" [-30 40 100] "blackbody L" [3000 1.5]
      AttributeBegin
      Material "glass"
      Shape "sphere" "float radius" [1]
      AttributeEnd
      AttributeBegin
      Texture "checks" "spectrum" "checkerboard" "float uscale" [8] "float vscale" [8] "rgb tex1" [0.1 0.1 0.1] "rgb tex2" [0.8 0.8 0.8]
      Material "matte" "texture Kd" ["checks"]
      Translate 0 0 -1
      Shape "trianglemesh" "integer indices" [0 1 2 0 2 3] "point3 P" [-20 -20 0 20 -20 0 20 20 0 -20 20 0] "float st" [0 0 1 0 1 1 0 1]
      AttributeEnd
      WorldEnd
    PBRT
  end

  it "can generate the 'miscquads' scene" do
    # This example is from the pbrt-v3-scenes repository.

    builder = PBRT::Builder.new do
      film.image(xresolution: 1500, yresolution: 750, filename: "miscquads.exr")

      sampler.halton(pixelsamples: 512)

      scale(-1, 1, 1)
      look_at([0, 3, 8], [0, 0.8, 0], [0, 1, 0])
      camera.perspective(fov: 21)

      world_begin do
        attribute_begin do
          coord_sys_transform("camera")
          area_light_source.diffuse(L: color(8, 8, 8))
          translate(0, 2, -10)
          material.matte(Kd: color(0, 0, 0))
          shape.disk(radius: 3)
        end

        attribute_begin do
          area_light_source.diffuse(L: color(3.2, 3.2, 3.2))
          translate(0, 10, 0)
          rotate(90, 1, 0, 0)
          material.matte(Kd: color(0, 0, 0))
          shape.disk(radius: 20)
        end

        attribute_begin do
          material.matte(Kd: color(0.3, 0.3, 0.3))
          shape.trianglemesh(
            indices: [0, 1, 2, 2, 0, 3],
            P: [[-10, 0, -10], [10, 0, -10], [10, 0, 10], [-10, 0, 10]],
          )
          shape.trianglemesh(
            indices: [0, 1, 2, 2, 0, 3],
            P: [[-10, 0, -10], [10, 0, -10], [10, 9, -10], [-10, 9, -10]],
          )
          shape.trianglemesh(
            indices: [0, 1, 2, 2, 0, 3],
            P: [[-10, 0, -10], [-10, 0, 10], [-10, 9, 10], [-10, 9, -10]],
          )
        end

        texture("g").color.imagemap(filename: "textures/grid.png")
        texture("grid").color.scale(tex1: texture("g"), tex2: color(0.75, 0.75, 0.75))

        material.uber(
          Kd: texture("grid"),
          Ks: color(0.1, 0.1, 0.1),
          opacity: color(0.8, 0.8, 0.8)
        )

        attribute_begin do
          translate(-1.75, 0, -0.4)
          scale(0.7, 1.8, 0.7)
          rotate(60, 0, 1, 0)
          rotate(-90, 1, 0, 0)
          shape.paraboloid
        end

        attribute_begin do
          translate(1.75, 0, -0.4)
          scale(0.7, 1.8, 0.7)
          rotate(54, 0, 1, 0)
          rotate(-90, 1, 0, 0)
          shape.cone
        end

        attribute_begin do
          translate(-0.15, 1.35, -0.4)
          scale(0.5, 1.7, 0.5)
          rotate(150, 0, 1, 0)
          rotate(90, 1, 0, 0)
          shape.hyperboloid(p1: [1, 0, 0], p2: [0.8, 1, 0.8])
        end
      end
    end

    expect(builder.to_s.lines).to eq(<<~PBRT.lines)
      Film "image" "integer xresolution" [1500] "integer yresolution" [750] "string filename" ["miscquads.exr"]
      Sampler "halton" "integer pixelsamples" [512]
      Scale -1 1 1
      LookAt 0 3 8 0 0.8 0 0 1 0
      Camera "perspective" "float fov" [21]
      WorldBegin
      AttributeBegin
      CoordSysTransform "camera"
      AreaLightSource "diffuse" "color L" [8 8 8]
      Translate 0 2 -10
      Material "matte" "color Kd" [0 0 0]
      Shape "disk" "float radius" [3]
      AttributeEnd
      AttributeBegin
      AreaLightSource "diffuse" "color L" [3.2 3.2 3.2]
      Translate 0 10 0
      Rotate 90 1 0 0
      Material "matte" "color Kd" [0 0 0]
      Shape "disk" "float radius" [20]
      AttributeEnd
      AttributeBegin
      Material "matte" "color Kd" [0.3 0.3 0.3]
      Shape "trianglemesh" "integer indices" [0 1 2 2 0 3] "point3 P" [-10 0 -10 10 0 -10 10 0 10 -10 0 10]
      Shape "trianglemesh" "integer indices" [0 1 2 2 0 3] "point3 P" [-10 0 -10 10 0 -10 10 9 -10 -10 9 -10]
      Shape "trianglemesh" "integer indices" [0 1 2 2 0 3] "point3 P" [-10 0 -10 -10 0 10 -10 9 10 -10 9 -10]
      AttributeEnd
      Texture "g" "color" "imagemap" "string filename" ["textures/grid.png"]
      Texture "grid" "color" "scale" "texture tex1" ["g"] "color tex2" [0.75 0.75 0.75]
      Material "uber" "texture Kd" ["grid"] "color Ks" [0.1 0.1 0.1] "color opacity" [0.8 0.8 0.8]
      AttributeBegin
      Translate -1.75 0 -0.4
      Scale 0.7 1.8 0.7
      Rotate 60 0 1 0
      Rotate -90 1 0 0
      Shape "paraboloid"
      AttributeEnd
      AttributeBegin
      Translate 1.75 0 -0.4
      Scale 0.7 1.8 0.7
      Rotate 54 0 1 0
      Rotate -90 1 0 0
      Shape "cone"
      AttributeEnd
      AttributeBegin
      Translate -0.15 1.35 -0.4
      Scale 0.5 1.7 0.5
      Rotate 150 0 1 0
      Rotate 90 1 0 0
      Shape "hyperboloid" "point3 p1" [1 0 0] "point3 p2" [0.8 1 0.8]
      AttributeEnd
      WorldEnd
    PBRT
  end
end

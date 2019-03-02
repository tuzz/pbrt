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
end

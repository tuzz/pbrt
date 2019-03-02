## PBRT

A Ruby gem to generate scene description files for the third edition of [Physically Based Rendering](http://www.pbr-book.org/).

This gem implements its [file format specification](https://pbrt.org/fileformat-v3.html) and wraps it in a friendly DSL.

## Overview

This gem makes it easier to generate scene description files, because:
- It provides methods that only accept valid parameter names
- It knows the types of parameters and automatically adds them for you
- It closely resembles the structure in the documentation
- It's easy to script with bits of Ruby
- It has no dependencies and streams to a plain IO object

## Example

This generates [the example](https://pbrt.org/fileformat-v3.html#example) from the documentation:

```ruby
require "pbrt"

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

puts builder.to_s
```

[This](https://pbrt.org/simple.png) is what it looks like when rendered.

## How do I use the gem?

As you can see in the example above, the gem has a `PBRT::Builder` that takes a block
where you can call methods to generate 'directives'. The methods you can call directly
correspond to the documentation.

For example, in the [Transformations section](https://pbrt.org/fileformat-v3.html#transformations)
there is an 'Identity' directive which you can generate with the `identity` method.

There are two kinds of directives:
  - Those that take plain arguments
  - Those that take arguments as named parameter lists

For example:

```ruby
# plain arguments
translate(1, 2, 3)

# parameter list
shape.sphere(radius: 2, zmin: 0.2, zmax: 0.7)
```

The majority of directives have 'implementations' such as the 'perspective' implementation
for the 'Camera' directive or the 'sphere' implementation for the 'Shape' directive. To
specify this, call the method on the directive:

```ruby
camera.perspective
sampler.halton(pixelsamples: 16)
shape.sphere(radius: 1)
light_source.spotlight(from: [0, 1, 0], to: [0, 0, 0])
```

All directives and implementations are specified in the documentation as well as the names
of parameters and their types. For parameters that have type `point2`, `point3`, `vector2` etc,
you can pass an array and if the parameter takes several points e.g. `point[4]` you can either
pass a flat array or group the individual points into sub-arrays:

```ruby
# flat array
shape.curve(P: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])

# sub-arrays
shape.curve(P: [[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11]])
```

There is no difference (other than readability). They will generate the same code. In fact, the
same is true for any parameter that takes multiple values. For example, the
[`LookAt` directive](https://pbrt.org/fileformat-v3.html#transformations) takes 9 floats that may
be grouped into sub-arrays for clarity:

```ruby
look_at(
  [3, 4, 1.5],   # eye
  [0.5, 0.5, 0], # look at point
  [0, 0, 1],     # up vector
)
```

Some directives come in pairs like `WorldBegin` / `WorldEnd` and `AttributeBegin` / `AttributeEnd`.
The gem only provides a method for 'begin' and lets you pass a block to specify what goes inside it:

```ruby
world_begin do
  transform(1, 2, 3)
  sphere.shape

  attribute_begin do
    # ...
  end
end
```

Finally, there are some directives that take a name such as [`Texture`](https://pbrt.org/fileformat-v3.html#textures)
and [`MakeNamedMaterial`](https://pbrt.org/fileformat-v3.html#materials). In these cases, pass the name in to the
top-level method before calling others on it.

Textures also take a 'class' which is either 'spectrum' or 'float' which can be specified with a chained method call:

```ruby
texture("mytexture").spectrum.checkerboard(dimension: 2)
make_named_material("mymaterial").plastic(roughness: 0.1)
```

If you can't figure out how to call the directive / implementation you want, this gem has an example of every single
one being called in it's [`builder_spec.rb`](https://github.com/tuzz/pbrt/blob/master/spec/pbrt/builder_spec.rb).

## Spectrums and Textures

Some parameters take types that are `spectrum`, `spectrum texture`, `float texture`, `spectrum / float texture`.

A spectrum type is used to specify a color spectrum which can be represented in different ways.
[Parameter Lists](https://pbrt.org/fileformat-v3.html#parameter-lists) section for more details. When a parameter
has the spectrum type, wrap its arguments with one of the representations:

```ruby
# rgb
light_source.point(scale: rgb(0.8, 0.1, 0.1))

# xyz
light_source.point(scale: xyz(0.8, 0.1, 0.1))

# sampled
light_source.point(scale: sampled([300, 0.3, 400, 0.6])
light_source.point(scale: sampled("filename"))

# blackbody
light_source.point(scale: blackbody(6500, 1))
```

Occasionally this can be omitted if it can be inferred:

```ruby
light_source.point(scale: "filename")
```

But it's usually better to include it to make your intent clearer.

A type like `spectrum texture` actually means the parameter accepts either a spectrum or the name of a texture
that you have created with the 'Texture' directive. In this case, the string "filename" is ambiguous because it could
be a file containing spectrum sample data, or it could be the name of one of your textures.

If things are ambiguous, PBRT will raise an error:

```ruby
AmbiguousArgumentError:
  Please specify whether "filename" is a spectrum or texture.
  If it's a texture, wrap it with: texture("filename")
  If it's a spectrum, wrap it with its representation: sampled("filename")
  Valid representations are: rgb, xyz, sampled and blackbody
```

For the `float texture` type, it can always be decided what you meant because a `float` is always a number and a
`texture` is always a string.

There's only one case where the type can be ambiguous and PBRT will not raise an error. If you enter a number for the
`spectrum / float texture`, PBRT will assume you meant a float rather than a spectrum as floats are much more common, but
if you really want a spectrum then wrap the argument in one of its representations (e.g. rgb).

## IO / Builder pattern

In the example above, a block is being passed to the `PBRT::Builder`, but you can also use this as a more traditional
builder by calling methods on it:

```ruby
builder = PBRT::Builder.new
builder.world_begin do
  builder.translate(1, 2, 3)
  builder.shape.sphere
end
```

Builder methods return `self` so you can chain methods if you'd like:

```ruby
translate(1, 2, 3).shape.sphere(radius: 1)
```

When a builder is constructed, it takes an IO object that it streams its directives to. You can pass one of your own,
for example, if you want to stream your directives straight into a file to save on memory usage:

```ruby
File.open("myscene.pbrt", "w") do |file|
  PBRT::Builder.new(io: file) do
    translate(1, 2, 3)
    shape.sphere(radius: 1)
  end
end
```

## Things this gem won't do

This gem does some basic checking of parameter and can infer types for you, but it won't do much beyond that. Specifically:

- It won't error if you pass values of the wrong type
- It won't error if you pass arrays with too many / few values
- It won't error if you use directives inappropriately, e.g. specifying `LookAt` inside the `WorldBegin` section
- It won't explain what any of the directives mean or how to use them

It would be great if it did some of those things, and I'd happily welcome pull requests to add them.

## Quirks

- The 02sequence sampler is called o2sequence because Ruby methods can't begin with a number
- The texture method can be used for adding a directive as well as disambiguating values
- Every single material parameter can be used in shape directives because the specification allows it
- You can actually generate multiple renders for the same scene by adding more `WorldBegin` directives

## Contribution

[MIT License](LICENSE)

I am in no way affiliated with PBRT or any of its authors.

If you find this gem useful, I'd love to hear how you're using it on [Twitter](https://twitter.com/chrispatuzzo) and will happily
welcome pull requests or suggestions for improvement.

I intend to use this on some other projects of my own, so [a search of my GitHub repositories](https://github.com/search?q=user%3Atuzz+pbrt)
might be useful if you're planning to use it. Good luck.

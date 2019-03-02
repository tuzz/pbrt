module PBRT
  class Builder
    attr_accessor :io

    def initialize(io: StringIO.new, &block)
      self.io = io

      instance_eval &block if block_given?
    end

    def to_s
      io.string
    end

    def camera
      Camera.new(self)
    end

    def sampler
      Sampler.new(self)
    end

    def film
      Film.new(self)
    end

    def pixel_filter
      PixelFilter.new(self)
    end

    def integrator
      Integrator.new(self)
    end

    def accelerator
      Accelerator.new(self)
    end

    def shape
      Shape.new(self)
    end

    def light_source
      LightSource.new(self)
    end

    def area_light_source
      AreaLightSource.new(self)
    end

    def identity
      write Statement.fixed_size("Identity", 0)
    end

    def translate(*args)
      write Statement.fixed_size("Translate", 3, args)
    end

    def scale(*args)
      write Statement.fixed_size("Scale", 3, args)
    end

    def rotate(*args)
      write Statement.fixed_size("Rotate", 4, args)
    end

    def look_at(*args)
      write Statement.fixed_size("LookAt", 9, args)
    end

    def coordinate_system(*args)
      write Statement.fixed_size("CoordinateSystem", 1, args)
    end

    def coord_sys_transform(*args)
      write Statement.fixed_size("CoordSysTransform", 1, args)
    end

    def transform(*args)
      write Statement.fixed_size("Transform", 16, args)
    end

    def concat_transform(*args)
      write Statement.fixed_size("ConcatTransform", 16, args)
    end

    def transform_times(*args)
      write Statement.fixed_size("TransformTimes", 2, args)
    end

    def active_transform(*args)
      write Statement.fixed_size("ActiveTransform", 1, args)
    end

    def write(statement)
      io.puts statement
      self
    end
  end
end

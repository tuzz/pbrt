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

    def translate(*args)
      write Statement.fixed_size("Translate", 3, args)
    end

    def shape
      Shape.new(self)
    end

    def write(statement)
      io.puts statement
      self
    end
  end
end

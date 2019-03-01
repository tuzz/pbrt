module PBRT
  class Builder
    attr_accessor :io

    def initialize(io: StringIO.new)
      self.io = io
    end

    def to_s
      io.string
    end

    def translate(*args)
      io.puts Statement.fixed_size("Translate", 3, args)
    end

    def shape
      Shape.new(io)
    end
  end
end

module PBRT
  class Statement
    def self.fixed_size(*args)
      FixedSize.new(*args)
    end

    def self.variadic(*args)
      Variadic.new(*args)
    end
  end
end

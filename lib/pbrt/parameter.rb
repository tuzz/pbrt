module PBRT
  class Parameter
    def initialize(type, name)
      @type = type
      @name = name
    end

    def to_s
      %("#@type #@name")
    end
  end
end

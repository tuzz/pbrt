Gem::Specification.new do |s|
  s.name        = "pbrt"
  s.version     = "0.1.0"
  s.licenses    = ["MIT"]
  s.summary     = "PBRT"
  s.description = "A Ruby gem to generate scene description files for the third edition of Physically Based Rendering."
  s.author      = "Chris Patuzzo"
  s.email       = "chris@patuzzo.co.uk"
  s.homepage    = "https://github.com/tuzz/pbrt"
  s.files       = ["README.md"] + Dir["lib/**/*.*"]

  s.add_development_dependency "rspec", "3.8.0"
end

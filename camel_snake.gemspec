$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "camel_snake_keys"
  s.version     = CamelSnakeKeys::VERSION
  s.authors     = ["Josh Buermann"]
  s.email       = ["buermann@gmail.com"]
  s.homepage    = "https://github.com/buermann/camel_snake_keys"
  s.summary     = "Convert nested data structure hash keys between camel and snake case."
  s.description = ""
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n").sort
  s.test_files    = `git ls-files -- spec/*`.split("\n")

  s.required_ruby_version = '~> 2.0'
  s.add_dependency "activesupport"

  s.add_development_dependency "rspec"
  s.add_development_dependency "activesupport"
end

require 'coveralls'
Coveralls.wear!
require 'camel_snake_keys'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
end

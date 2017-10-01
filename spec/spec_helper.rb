ENV["RACK_ENV"] ||= "test"

require_relative "../config/application"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.color = true
  config.formatter = :doc
end

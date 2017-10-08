ENV["RACK_ENV"] ||= "test"

require_relative "../config/application"

require_all "spec/support"
require "webmock/rspec"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.color = true
  config.formatter = :doc
end

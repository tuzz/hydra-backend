ENV["RACK_ENV"] ||= "test"

require_relative "../config/application"

Dir["spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.color = true
  config.formatter = :doc
end

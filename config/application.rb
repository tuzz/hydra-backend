ENV["RACK_ENV"] ||= "development"

require "bundler/setup"
require "yaml"

Bundler.require(:default, ENV.fetch("RACK_ENV"))

$LOAD_PATH << File.expand_path("..", __dir__)

require "config/routes"

Dir["config/initializers/**/*.rb"].each { |f| require f }
Dir["app/**/*.rb"].each { |f| require f }

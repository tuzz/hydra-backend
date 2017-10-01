ENV["RACK_ENV"] ||= "development"

require "bundler/setup"

Bundler.require(:default, ENV.fetch("RACK_ENV"))

$LOAD_PATH << File.expand_path("..", __dir__)

require "config/routes"

Dir["app/**/*.rb"].each { |f| require f }

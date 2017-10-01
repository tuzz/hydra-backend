ENV["RACK_ENV"] ||= "development"

require "bundler/setup"
require "yaml"

Bundler.require(:default, ENV.fetch("RACK_ENV"))

$LOAD_PATH << File.expand_path("..", __dir__)

require "config/routes"

def require_all(directory)
  Dir["#{directory}/**/*.rb"].each { |f| require f }
end

require_all "config/initializers"
require_all "app"

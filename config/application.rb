require "bundler/setup"

Bundler.require

$LOAD_PATH << File.expand_path("..", __dir__)

require "config/routes"

Dir["app/**/*.rb"].each { |f| require f }

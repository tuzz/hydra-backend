yaml = File.read("config/database.yml")
env = ENV.fetch("RACK_ENV")

all_config = YAML.load(yaml)
env_config = all_config.fetch(env)

ActiveRecord::Base.establish_connection(env_config)

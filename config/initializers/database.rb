module Database
  class << self
    def config
      @config ||= YAML.load(File.read("config/database.yml"))
    end

    def env
      ENV.fetch("RACK_ENV")
    end

    def connect!
      ActiveRecord::Base.establish_connection(config.fetch(env))
    end

    def create!
      config.each { |_, c| system("createdb #{c.fetch("database")}") }
    end

    def migrate!
      ActiveRecord::Migrator.migrate("db/migrate")
      dump!
    end

    def rollback!
      ActiveRecord::Migrator.rollback("db/migrate")
      dump!
    end

    def dump!
      connection = ActiveRecord::Base.connection
      schema = File.open("db/schema.rb", "w")

      ActiveRecord::SchemaDumper.dump(connection, schema)
    end
  end
end

Database.connect!

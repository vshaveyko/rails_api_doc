require 'rails/generators'
require 'rails/generators/migration'

module RailsApiDoc
  class InstallGenerator < ::Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    desc "add the migrations"
    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def copy_migrations
      migration_template "api_datum_migration.rb", "db/migrate/generate_rails_api_documentation_attributes_table.rb"
    end
  end
end

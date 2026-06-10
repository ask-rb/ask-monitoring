module Ask
  module Monitoring
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Installs ask-monitoring: copies migration, creates initializer, mounts engine."

      def copy_migration
        rake "ask_monitoring:install:migrations"
      end

      def create_initializer
        template "initializer.rb", "config/initializers/ask_monitoring.rb"
      end

      def mount_engine
        route 'mount Ask::Monitoring::Engine => "/ask/monitoring"'
      end
    end
  end
end

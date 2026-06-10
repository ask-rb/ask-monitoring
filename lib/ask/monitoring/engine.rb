module Ask
  module Monitoring
    class Engine < ::Rails::Engine
      isolate_namespace Ask::Monitoring

      config.generators do |g|
        g.test_framework :minitest
      end

      initializer "ask-monitoring.migrations" do |app|
        unless app.root.to_s.match?(root.to_s)
          config.paths["db/migrate"].expanded.each do |path|
            app.config.paths["db/migrate"] << path
          end
        end
      end

      initializer "ask-monitoring.subscribe" do
        Ask::Instrumentation.subscribe(/\.ask$/, EventSubscriber.new)
      end
    end
  end
end

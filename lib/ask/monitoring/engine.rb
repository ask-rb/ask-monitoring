module Ask
  module Monitoring
    class Engine < Rails::Engine
      isolate_namespace Ask::Monitoring

      config.generators do |g|
        g.test_framework :minitest
      end

      initializer "ask-monitoring.subscribe" do
        Ask::Instrumentation.subscribe(/\.ask$/, EventSubscriber.new)
      end
    end
  end
end

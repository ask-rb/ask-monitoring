require "ask/instrumentation"
require_relative "monitoring/version"

module Ask
  module Monitoring
    autoload :Engine, "ask/monitoring/engine"
    autoload :EventSubscriber, "ask/monitoring/event_subscriber"
    autoload :DashboardController, "ask/monitoring/dashboard_controller"

    module Metrics
      autoload :Base, "ask/monitoring/metrics/base"
      autoload :Cost, "ask/monitoring/metrics/cost"
      autoload :Throughput, "ask/monitoring/metrics/throughput"
      autoload :ErrorCount, "ask/monitoring/metrics/error_count"
      autoload :ResponseTime, "ask/monitoring/metrics/response_time"
    end

    module Channels
      autoload :Base, "ask/monitoring/channels/base"
      autoload :Slack, "ask/monitoring/channels/slack"
      autoload :Email, "ask/monitoring/channels/email"
    end

    class << self
      attr_accessor :alert_cooldown, :alert_rules

      def configure
        yield self
      end
    end

    self.alert_cooldown = 5.minutes
    self.alert_rules = []
  end
end

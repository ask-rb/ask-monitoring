require "ask/instrumentation"
require_relative "monitoring/version"

module Ask
  # LLM Monitoring Dashboard for Rails.
  #
  # A Rails engine that subscribes to +Ask::Instrumentation+ events,
  # persists them, and provides a real-time dashboard for monitoring
  # LLM cost, throughput, error rates, and response times.
  #
  # == Usage
  #
  #   # In your Rails app:
  #   # gem "ask-monitoring"
  #   # rails generate ask:monitoring:install
  #   # rails db:migrate
  #
  #   # Then visit /ask/monitoring
  module Monitoring
    autoload :Engine,           "ask/monitoring/engine"
    autoload :EventSubscriber,  "ask/monitoring/event_subscriber"
    autoload :Cost,             "ask/monitoring/cost"

    module Metrics
      autoload :Base,          "ask/monitoring/metrics/base"
      autoload :Cost,          "ask/monitoring/metrics/cost"
      autoload :Throughput,    "ask/monitoring/metrics/throughput"
      autoload :ErrorCount,    "ask/monitoring/metrics/error_count"
      autoload :ResponseTime,  "ask/monitoring/metrics/response_time"
    end

    module Channels
      autoload :Base,   "ask/monitoring/channels/base"
      autoload :Slack,  "ask/monitoring/channels/slack"
      autoload :Email,  "ask/monitoring/channels/email"
    end

    class << self
      # @!attribute [rw] alert_cooldown
      #   Minimum time between repeated alerts from the same rule.
      #   @return [ActiveSupport::Duration] (default: 5.minutes)
      attr_accessor :alert_cooldown

      # @!attribute [rw] alert_rules
      #   Array of alert rule hashes. Each rule must have:
      #     * +:name+ — String label
      #     * +:condition+ — Proc receiving a metrics hash
      #     * +:channels+ — Array of channel symbols (+:slack+, +:email+)
      #     * +:cooldown+ — (optional) Duration override per rule
      #   @return [Array<Hash>]
      attr_accessor :alert_rules

      # Yields self for configuration.
      def configure
        yield self
      end
    end

    self.alert_cooldown = 300 # 5 minutes in seconds
    self.alert_rules = []
  end
end

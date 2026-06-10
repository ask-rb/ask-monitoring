Ask::Monitoring.configure do |config|
  # Add alert rules:
  # config.alert_rules << {
  #   name: "High error rate",
  #   condition: ->(metrics) { metrics.error_rate > 0.05 },
  #   channels: [:slack]
  # }

  # Register custom pricing:
  # Ask::Monitoring::Cost.register("my-provider/my-model", input: 0.001, output: 0.002)
end

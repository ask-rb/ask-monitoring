require_relative "test_helper"
require "ask/monitoring"

class AlertRulesTest < Minitest::Test
  def setup
    Ask::Monitoring.alert_rules = []
    Ask::Monitoring.alert_cooldown = 300
  end

  def test_alert_rules_is_array
    assert_equal [], Ask::Monitoring.alert_rules
  end

  def test_can_add_alert_rule
    Ask::Monitoring.alert_rules << {
      name: "High error rate",
      condition: ->(metrics) { metrics[:error_rate] > 0.05 },
      channels: [:slack]
    }
    assert_equal 1, Ask::Monitoring.alert_rules.length
  end

  def test_alert_cooldown_default
    assert_equal 300, Ask::Monitoring.alert_cooldown
  end

  def test_configure_yields_self
    Ask::Monitoring.configure do |config|
      config.alert_cooldown = 600
      config.alert_rules << { name: "test", condition: ->(m) { false }, channels: [:slack] }
    end
    assert_equal 600, Ask::Monitoring.alert_cooldown
    assert_equal 1, Ask::Monitoring.alert_rules.length
  end
end

# frozen_string_literal: true

require_relative "../test_helper"
require "ask/monitoring/channels/base"
require "ask/monitoring/channels/slack"

class SlackChannelTest < Minitest::Test
  def test_initialize_with_webhook
    channel = Ask::Monitoring::Channels::Slack.new(webhook_url: "https://hooks.slack.com/test")
    assert channel
  end

  def test_format_alert_includes_name
    channel = Ask::Monitoring::Channels::Slack.new(webhook_url: "https://hooks.slack.com/test")
    formatted = channel.__send__(:format_alert, {
      name: "High Error Rate",
      message: "Error rate exceeded threshold",
      metrics: { error_rate: 0.15 }
    })
    assert_includes formatted, "High Error Rate"
    assert_includes formatted, "Error rate exceeded threshold"
    assert_includes formatted, "15"
  end

  def test_format_alert_with_zero_error_rate
    channel = Ask::Monitoring::Channels::Slack.new(webhook_url: "https://hooks.slack.com/test")
    formatted = channel.__send__(:format_alert, {
      name: "Test Alert",
      message: "Everything is fine",
      metrics: { error_rate: 0.0 }
    })
    assert_includes formatted, "0%"
  end

  def test_format_alert_without_metrics
    channel = Ask::Monitoring::Channels::Slack.new(webhook_url: "https://hooks.slack.com/test")
    formatted = channel.__send__(:format_alert, {
      name: "Minimal Alert",
      message: "Just a test"
    })
    assert_includes formatted, "Minimal Alert"
    assert_includes formatted, "0%"
  end

  def test_deliver_requires_valid_webhook
    channel = Ask::Monitoring::Channels::Slack.new(webhook_url: "https://hooks.slack.com/nonexistent")
    refute channel.deliver({ name: "test", message: "test" })
  end
end

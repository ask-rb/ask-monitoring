require_relative "../test_helper"
require "ask/monitoring/channels/base"
require "ask/monitoring/channels/slack"

class SlackTest < Minitest::Test
  def test_responds_to_deliver
    channel = Ask::Monitoring::Channels::Slack.new(webhook_url: "https://hooks.slack.com/test")
    assert_respond_to channel, :deliver
  end

  def test_requires_webhook_url
    channel = Ask::Monitoring::Channels::Slack.new(webhook_url: "https://hooks.slack.com/test")
    assert channel
  end
end

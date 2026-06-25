# frozen_string_literal: true

require_relative "../test_helper"
require "ask/monitoring/channels/base"
require "ask/monitoring/channels/email"

class EmailChannelTest < Minitest::Test
  def test_email_initializes
    channel = Ask::Monitoring::Channels::Email.new(from: "alerts@example.com", to: "admin@example.com")
    assert channel
  end

  def test_deliver_raises_not_implemented
    channel = Ask::Monitoring::Channels::Email.new(from: "alerts@example.com", to: "admin@example.com")
    assert_raises(NotImplementedError) { channel.deliver({}) }
  end
end

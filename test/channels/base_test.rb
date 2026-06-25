# frozen_string_literal: true

require_relative "../test_helper"
require "ask/monitoring/channels/base"

class BaseChannelTest < Minitest::Test
  def test_base_deliver_raises_not_implemented
    channel = Ask::Monitoring::Channels::Base.new
    assert_raises(NotImplementedError) { channel.deliver({}) }
  end
end

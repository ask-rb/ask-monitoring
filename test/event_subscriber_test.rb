# frozen_string_literal: true

require_relative "test_helper"
require "ask/monitoring/event_subscriber"

# Stub Rails.logger for testing
module Rails
  class << self
    def logger
      @logger ||= Logger.new(File::NULL)
    end
  end
end

class EventSubscriberTest < Minitest::Test
  def setup
    @subscriber = Ask::Monitoring::EventSubscriber.new
  end

  def test_subscriber_responds_to_call
    assert_respond_to @subscriber, :call
  end

  def test_cost_calculation_with_payload
    cost = @subscriber.send(:calculate_cost, provider: "openai", model: "gpt-4", input_tokens: 100, output_tokens: 50)
    assert_kind_of Float, cost
    assert cost > 0
  end

  def test_cost_calculation_with_empty_model
    cost = @subscriber.send(:calculate_cost, provider: nil, model: nil)
    assert_equal 0.0, cost
  end

  def test_cost_calculation_with_partial_tokens
    cost = @subscriber.send(:calculate_cost, provider: "openai", model: "gpt-4", input_tokens: 100, output_tokens: nil)
    assert_kind_of Float, cost
    assert cost > 0
  end
end

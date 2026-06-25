# frozen_string_literal: true

require_relative "../test_helper"
require "ask/monitoring/metrics/base"
require "ask/monitoring/metrics/error_count"

class ErrorCountTest < Minitest::Test
  def test_responds_to_rate
    metric = Ask::Monitoring::Metrics::ErrorCount.new([])
    assert_respond_to metric, :rate
  end

  def test_responds_to_as_chart_data
    metric = Ask::Monitoring::Metrics::ErrorCount.new([])
    assert_respond_to metric, :as_chart_data
  end

  def test_inherits_from_base
    assert Ask::Monitoring::Metrics::ErrorCount < Ask::Monitoring::Metrics::Base
  end
end

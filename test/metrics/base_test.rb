# frozen_string_literal: true

require_relative "../test_helper"
require "ask/monitoring/metrics/base"

class BaseMetricsTest < Minitest::Test
  def test_base_raises_not_implemented
    metric = Ask::Monitoring::Metrics::Base.new([])
    assert_raises(NotImplementedError) { metric.as_chart_data }
  end

  def test_scope_accessible
    scope = [1, 2, 3]
    metric = Ask::Monitoring::Metrics::Base.new(scope)
    assert_equal scope, metric.scope
  end
end

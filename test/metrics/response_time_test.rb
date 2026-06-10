require_relative "../test_helper"
require "ask/monitoring/metrics/base"
require "ask/monitoring/metrics/response_time"

class ResponseTimeTest < Minitest::Test
  FakeScope = Struct.new(:records) do
    def pluck(col)
      records.map { |r| r[col] }.compact
    end
  end

  def test_percentiles_with_empty_data
    result = Ask::Monitoring::Metrics::ResponseTime.new(FakeScope.new([])).percentiles
    assert_equal 0, result[:p50]
    assert_equal 0, result[:p95]
    assert_equal 0, result[:p99]
  end

  def test_percentiles_with_single_value
    scope = FakeScope.new([{ duration: 0.1 }])
    result = Ask::Monitoring::Metrics::ResponseTime.new(scope).percentiles
    assert_in_delta 100, result[:p50], 0.1
  end

  def test_percentiles_with_100_values
    records = (1..100).map { |i| { duration: i * 0.001 } }
    result = Ask::Monitoring::Metrics::ResponseTime.new(FakeScope.new(records)).percentiles
    assert_in_delta 50, result[:p50], 2
    assert_in_delta 95, result[:p95], 2
    assert_in_delta 99, result[:p99], 2
  end

  def test_as_chart_data_aliases_percentiles
    scope = FakeScope.new([{ duration: 0.1 }])
    metric = Ask::Monitoring::Metrics::ResponseTime.new(scope)
    assert_equal metric.percentiles, metric.as_chart_data
  end
end

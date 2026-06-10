require_relative "test_helper"
require "ask/monitoring/cost"

class CostTest < Minitest::Test
  def teardown
    Ask::Monitoring::Cost.custom_pricing = {}
  end

  def test_gpt4_pricing
    cost = Ask::Monitoring::Cost.for("openai/gpt-4", tokens: { input: 100, output: 50 })
    expected = (100.0 / 1000 * 0.03) + (50.0 / 1000 * 0.06)
    assert_in_delta expected, cost, 0.0001
  end

  def test_unknown_model_returns_zero
    cost = Ask::Monitoring::Cost.for("unknown/model", tokens: { input: 100, output: 50 })
    assert_equal 0.0, cost
  end

  def test_zero_tokens_returns_zero
    cost = Ask::Monitoring::Cost.for("openai/gpt-4", tokens: { input: 0, output: 0 })
    assert_equal 0.0, cost
  end

  def test_custom_pricing
    Ask::Monitoring::Cost.register("custom/model", input: 0.01, output: 0.02)
    cost = Ask::Monitoring::Cost.for("custom/model", tokens: { input: 1000, output: 500 })
    expected = (1000.0 / 1000 * 0.01) + (500.0 / 1000 * 0.02)
    assert_in_delta expected, cost, 0.0001
  end

  def test_custom_overrides_builtin
    Ask::Monitoring::Cost.register("openai/gpt-4", input: 0.001, output: 0.002)
    cost = Ask::Monitoring::Cost.for("openai/gpt-4", tokens: { input: 1000, output: 1000 })
    expected = (1000.0 / 1000 * 0.001) + (1000.0 / 1000 * 0.002)
    assert_in_delta expected, cost, 0.0001
  end

  def test_all_known_models_have_valid_pricing
    Ask::Monitoring::Cost::PRICING.each do |model, pricing|
      refute_nil pricing[:input], "#{model} missing input price"
      refute_nil pricing[:output], "#{model} missing output price"
      assert pricing[:input] > 0, "#{model} input price should be positive"
      assert pricing[:output] > 0, "#{model} output price should be positive"
    end
  end

  def test_missing_tokens_default_to_zero
    cost = Ask::Monitoring::Cost.for("openai/gpt-4", tokens: {})
    assert_equal 0.0, cost
  end
end

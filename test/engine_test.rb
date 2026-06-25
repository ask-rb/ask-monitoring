# frozen_string_literal: true

require_relative "test_helper"

class EngineTest < Minitest::Test
  def test_engine_file_exists
    path = File.expand_path("../lib/ask/monitoring/engine.rb", __dir__)
    assert File.exist?(path)
    content = File.read(path)
    assert_includes content, "isolate_namespace"
    assert_includes content, "initializer"
  end

  def test_routes_file_exists
    path = File.expand_path("../config/routes.rb", __dir__)
    assert File.exist?(path), "Routes file should exist"
    content = File.read(path)
    assert_includes content, "root to:"
    assert_includes content, "dashboard"
    assert_includes content, "metrics"
  end

  def test_routes_define_root_and_metrics
    path = File.expand_path("../config/routes.rb", __dir__)
    content = File.read(path)
    assert_match(%r{root\s+to:\s+"dashboard#index"}, content)
    assert_match(%r{get\s+"metrics"\s*,\s*to:\s+"dashboard#metrics"}, content)
  end

  def test_engine_subscribes_to_events
    path = File.expand_path("../lib/ask/monitoring/engine.rb", __dir__)
    content = File.read(path)
    assert_includes content, "subscribe"
    assert_includes content, "EventSubscriber"
  end

  def test_engine_has_migrations_config
    path = File.expand_path("../lib/ask/monitoring/engine.rb", __dir__)
    content = File.read(path)
    assert_includes content, "db/migrate"
  end

  def test_event_subscriber_file_exists
    path = File.expand_path("../lib/ask/monitoring/event_subscriber.rb", __dir__)
    assert File.exist?(path)
    assert_includes File.read(path), "class EventSubscriber"
  end

  def test_monitoring_module_configure
    Ask::Monitoring.configure do |config|
      config.alert_cooldown = 600
    end
    assert_equal 600, Ask::Monitoring.alert_cooldown
  end

  def test_monitoring_default_alert_rules
    Ask::Monitoring.alert_rules = []
    assert_equal [], Ask::Monitoring.alert_rules
  end

  def test_monitoring_engine_isolated
    path = File.expand_path("../lib/ask/monitoring/engine.rb", __dir__)
    assert_includes File.read(path), "isolate_namespace Ask::Monitoring"
  end

  def test_monitoring_generators_config
    path = File.expand_path("../lib/ask/monitoring/engine.rb", __dir__)
    assert_includes File.read(path), "test_framework"
    assert_includes File.read(path), "minitest"
  end
end

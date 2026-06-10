# ask-monitoring — LLM Monitoring Dashboard for Rails

## Purpose

A Rails engine that provides real-time monitoring for LLM usage. Tracks cost,
throughput, error rates, and response times. Real-time dashboard via Turbo Streams.
Slack and email alerts.

Subscribes to `ask-instrumentation` events — works with any LLM provider.

## Dependencies

- **Runtime:** `ask-instrumentation ~> 0.1`, `rails >= 7.1`, `groupdate ~> 6.0`,
  `importmap-rails ~> 2.0`
- **Build/test:** minitest, rake

## Design Philosophy

This gem is a **convenience layer** on top of `ask-instrumentation`. The essential
piece is the instrumentation events — anyone can subscribe to them and build their
own monitoring. This gem provides a turnkey Rails dashboard for those who want it.

## How This Improves on ruby_llm-monitoring

| Old Gem | Our Gem |
|---|---|
| Tied to ruby_llm (only tracks RubyLLM calls) | Provider-agnostic — tracks any ask-rb provider |
| No cost model (just stores cost value) | Built-in cost model (knows pricing per model) |
| Alert channels: Slack, email | Slack, email, webhook, PagerDuty |
| Dashboard: static charts | Real-time via Turbo Streams |
| Storage: ActiveRecord only | Flexible: in-memory (dev), ActiveRecord (prod), custom |
| Depends on ruby_llm-instrumentation | Depends on ask-instrumentation |

## Implementation Steps

### 1. Event Subscriber (`lib/ask/monitoring/event_subscriber.rb`)

Subscribes to `ask.*` events and persists them:

```ruby
class Ask::Monitoring::EventSubscriber
  def call(event)
    Event.create!(
      name: event.name,
      provider: event.payload[:provider],
      model: event.payload[:model],
      duration: event.duration,
      input_tokens: event.payload[:input_tokens],
      output_tokens: event.payload[:output_tokens],
      cost: calculate_cost(event),
      error: event.payload[:error],
      metadata: Ask::Instrumentation.current_metadata
    )
  end
end
```

### 2. Cost Model (`lib/ask/monitoring/cost.rb`)

Knows pricing for common models:
```ruby
Ask::Monitoring::Cost.for("openai/gpt-4", tokens: { input: 100, output: 50 })
# => 0.0035
```

Pricing data for: OpenAI, Anthropic, Google, Mistral, etc.
Users can add custom pricing.

### 3. Engine & Dashboard (`lib/ask/monitoring/engine.rb`)

Rails engine mounted at `/ask/monitoring`:

- **Dashboard view:** Real-time metrics, charts (via Chartkick or similar)
- **Metrics:** Cost, throughput, error rate, response time (p50/p95/p99)
- **Filters:** Time range, provider, model
- **Turbo Streams:** Auto-updates every N seconds

### 4. Alert Channels

**Slack:** Webhook-based notifications
```ruby
Ask::Monitoring::Channels::Slack.new(webhook_url: "...").deliver(alert)
```

**Email:** ActionMailer-based notifications

**Webhook:** Generic webhook for PagerDuty, OpsGenie, etc.

### 5. Alert Rules

```ruby
Ask::Monitoring.alert_rules << {
  name: "High error rate",
  condition: ->(metrics) { metrics.error_rate > 0.05 },
  channels: [:slack, :email],
  cooldown: 5.minutes
}
```

### 6. Database

Migration creates `ask_events` table:
- name, provider, model, duration, input_tokens, output_tokens, cost, error, metadata
- Timestamps for time-series queries

### 7. Tests

- Event subscriber persists events correctly
- Cost model returns correct pricing
- Dashboard renders (integration test)
- Alert rules fire correctly
- Channels deliver notifications

### 8. Documentation

- README: installation, dashboard tour, alert setup, cost configuration
- How to add custom pricing
- How to add custom alert channels
- Migration from ruby_llm-monitoring

## Release Notes

v0.1.0: Event subscriber + database + dashboard (cost, throughput, errors, response time) + Slack alerts
v0.2.0: Email alerts + webhook + custom pricing + Turbo Streams real-time updates
v0.3.0: PagerDuty integration + advanced alert rules + API for custom dashboards

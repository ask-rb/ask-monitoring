# ask-monitoring — LLM Monitoring Dashboard for Rails

## Purpose

A Rails engine that provides real-time monitoring for LLM usage. Tracks cost,
throughput, error rates, and response times. Real-time updates via Turbo Streams.
Slack alerts.

Subscribes to `ask-instrumentation` events — works with any LLM provider.

## Dependencies

- **Runtime:** `ask-instrumentation ~> 0.1`, `rails >= 7.1`, `groupdate ~> 6.0`,
  `importmap-rails ~> 2.0`, `turbo-rails ~> 2.0`
- **Build/test:** minitest, rake

## How This Improves on ruby_llm-monitoring

| Old Gem | Our Gem |
|---|---|
| Tied to ruby_llm (only tracks RubyLLM calls) | Provider-agnostic — tracks any ask-rb provider |
| No cost model (just stores cost value) | Built-in cost model (knows pricing per model) |
| Dashboard: static charts | Real-time via Turbo Streams |
| Depends on ruby_llm-instrumentation | Depends on ask-instrumentation |

## Implementation Steps

### 1. Event Subscriber (`lib/ask/monitoring/event_subscriber.rb`)

Subscribes to `ask.*` events and persists them.

### 2. Cost Model (`lib/ask/monitoring/cost.rb`)

Pricing for common models from OpenAI, Anthropic, Google, Mistral, and more.
Users can add custom pricing.

### 3. Engine & Dashboard (`lib/ask/monitoring/engine.rb`)

Rails engine mounted at `/ask/monitoring`:

- **Dashboard view:** Metrics rendered in Turbo Frames with auto-refresh
- **Real-time updates:** Turbo Streams push new data every 30 seconds
- **Metrics:** Cost, throughput, error rate, response time (p50/p95/p99)
- **Filters:** Time range, provider, model

### 4. Alerting

**Slack:** Webhook-based notifications
```ruby
Ask::Monitoring::Channels::Slack.new(webhook_url: "...").deliver(alert)
```

### 5. Alert Rules

```ruby
Ask::Monitoring.alert_rules << {
  name: "High error rate",
  condition: ->(metrics) { metrics.error_rate > 0.05 },
  channels: [:slack],
  cooldown: 5.minutes
}
```

### 6. Database

Migration creates `ask_events` table.

### 7. Tests

- Cost model returns correct pricing
- Alert rules fire correctly
- Channels deliver notifications
- Dashboard renders (integration test)

### 8. Documentation

- README: installation, dashboard tour, alert setup, cost configuration
- How to add custom pricing

## Release Notes

v0.1.0: Event subscriber + database + dashboard + Slack alerts + real-time Turbo Streams

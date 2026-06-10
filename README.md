# ask-monitoring

[![Gem Version](https://badge.fury.io/rb/ask-monitoring.svg)](https://badge.fury.io/rb/ask-monitoring)

LLM monitoring dashboard for Rails. Tracks cost, throughput, error rates, and
response times for all LLM calls in your application. Real-time updates via
Turbo Streams. Slack and email alerts.

Works with any LLM provider via `ask-instrumentation` events.

## Installation

```ruby
gem "ask-monitoring"
```

```bash
rails generate ask:monitoring:install
rails db:migrate
```

## Dashboard

Visit `/ask/monitoring` in your Rails app:

- **Cost** — spend per provider/model over time
- **Throughput** — requests per minute
- **Error Rate** — failures by provider/model
- **Response Time** — p50/p95/p99 latency

## Alerting

```ruby
# config/initializers/ask_monitoring.rb
Ask::Monitoring.alert_rules << {
  name: "High error rate",
  condition: ->(metrics) { metrics.error_rate > 0.05 },
  channels: [:slack, :email]
}
```

## Data

Events are persisted via `ActiveRecord`. Use Groupdate for flexible
time-series queries:

```ruby
Ask::Event.where(provider: "openai")
  .group_by_day(:created_at)
  .sum(:cost)
```

## License

MIT

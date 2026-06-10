# ask-monitoring

[![Gem Version](https://badge.fury.io/rb/ask-monitoring.svg)](https://badge.fury.io/rb/ask-monitoring)
[![CI](https://github.com/ask-rb/ask-monitoring/actions/workflows/ci.yml/badge.svg)](https://github.com/ask-rb/ask-monitoring/actions/workflows/ci.yml)

LLM monitoring dashboard for Rails. Tracks cost, throughput, error rates, and
response times for all LLM calls in your application. **Real-time updates via
Hotwire Turbo** — metrics auto-refresh every 30 seconds. Slack alerts.

Works with any LLM provider via `ask-instrumentation` events.

## Installation

```ruby
gem "ask-monitoring"
```

```bash
bundle install
rails generate ask:monitoring:install
rails db:migrate
```

Then visit `/ask/monitoring`.

## Dashboard

### Real-Time Updates

The dashboard uses Hotwire Turbo to auto-refresh every 30 seconds — no Redis,
no ActionCable, no JavaScript framework needed. Turbo Frames intercept the
refresh and smoothly morph in updated metrics without a full page reload.

### Metrics

| Metric | Description |
|---|---|
| **Cost** | Total spend in USD (calculated from token counts × model pricing) |
| **Throughput** | Total request count in the selected time range |
| **Error Rate** | Percentage of failed requests |
| **Response Time (p50)** | Median latency in milliseconds |

### Filters

Filter by time range (1h, 24h, 7d, 30d), provider, or model.

## Cost Tracking

```ruby
Ask::Monitoring::Cost.for("openai/gpt-4", tokens: { input: 100, output: 50 })
# => 0.006 (USD)
```

Built-in pricing for 22+ models across OpenAI, Anthropic, Google, Mistral,
Cohere, and Bedrock.

### Custom Pricing

```ruby
Ask::Monitoring::Cost.register("my-provider/my-model", input: 0.001, output: 0.002)
```

## Alerting

```ruby
Ask::Monitoring.configure do |config|
  config.alert_rules << {
    name: "High error rate",
    condition: ->(metrics) { metrics[:error_rate] > 0.05 },
    channels: [:slack]
  }
end
```

Slack alerts use Incoming Webhooks:

```ruby
Ask::Monitoring::Channels::Slack.new(
  webhook_url: ENV["SLACK_WEBHOOK_URL"]
).deliver(alert)
```

## Schema

| Column | Type | Description |
|---|---|---|
| `name` | string | Event name (e.g., chat.ask) |
| `provider` | string | LLM provider |
| `model` | string | Model identifier |
| `duration` | float | Duration in seconds |
| `input_tokens` | integer | Input token count |
| `output_tokens` | integer | Output token count |
| `cost` | decimal | Calculated cost in USD |
| `error` | text | Error message (if any) |
| `metadata` | jsonb | Context from `with_metadata` |
| `created_at` | timestamp | When the event occurred |

## Development

```bash
git clone https://github.com/ask-rb/ask-monitoring.git
cd ask-monitoring
bundle install
bundle exec rake test
```

## License

MIT

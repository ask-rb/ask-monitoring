# ask-monitoring

[![Gem Version](https://badge.fury.io/rb/ask-monitoring.svg)](https://badge.fury.io/rb/ask-monitoring)
[![CI](https://github.com/ask-rb/ask-monitoring/actions/workflows/ci.yml/badge.svg)](https://github.com/ask-rb/ask-monitoring/actions/workflows/ci.yml)

LLM monitoring dashboard for Rails. Tracks cost, throughput, error rates, and
response times for all LLM calls in your application. Slack alerts.

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

This will:
1. Copy the database migration to your app
2. Create `config/initializers/ask_monitoring.rb`
3. Mount the engine at `/ask/monitoring`

## Dashboard

Visit `/ask/monitoring` in your Rails app:

| Metric | Description |
|---|---|
| **Cost** | Spend per provider/model over time |
| **Throughput** | Requests per hour |
| **Error Rate** | Failures as a percentage |
| **Response Time** | p50 / p95 / p99 latency |

### Filters

Filter by time range (1h, 24h, 7d, 30d), provider, or model.

## Cost Tracking

The built-in cost model includes pricing for common models:

```ruby
Ask::Monitoring::Cost.for("openai/gpt-4", tokens: { input: 100, output: 50 })
# => 0.006 (USD)
```

### Supported Providers

- **OpenAI**: gpt-4o, gpt-4o-mini, gpt-4-turbo, gpt-4, gpt-3.5-turbo, o1-preview, o1-mini
- **Anthropic**: claude-3-opus, claude-3-sonnet, claude-3-haiku, claude-3.5-sonnet
- **Google**: gemini-1.5-pro, gemini-1.5-flash, gemini-1.0-pro
- **Mistral**: mistral-large, mistral-medium, mistral-small
- **Cohere**: command-r-plus, command-r
- **Bedrock**: claude-3-sonnet, claude-3-haiku

### Custom Pricing

```ruby
# In config/initializers/ask_monitoring.rb
Ask::Monitoring::Cost.register("openai/gpt-4", input: 0.03, output: 0.06)
Ask::Monitoring::Cost.register("my-provider/my-model", input: 0.001, output: 0.002)
```

Custom pricing overrides the built-in pricing for the same model key.

## Alerting

```ruby
# config/initializers/ask_monitoring.rb
Ask::Monitoring.configure do |config|
  config.alert_rules << {
    name: "High error rate",
    condition: ->(metrics) { metrics[:error_rate] > 0.05 },
    channels: [:slack]
  }

  config.alert_rules << {
    name: "High cost",
    condition: ->(metrics) { metrics[:cost] > 10.0 },
    channels: [:slack, :email]
  }
end
```

### Slack Alerts

Set your Slack Incoming Webhook URL:

```ruby
# In your alert handler:
Ask::Monitoring::Channels::Slack.new(
  webhook_url: ENV["SLACK_WEBHOOK_URL"]
).deliver(alert)
```

### Email Alerts (coming in v0.2.0)

## Data

Events are persisted via ActiveRecord. Use Groupdate for flexible queries:

```ruby
Ask::Event.where(provider: "openai")
  .group_by_day(:created_at)
  .sum(:cost)
```

### Schema

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
| `metadata` | jsonb | Context metadata (user_id, session_id, etc.) |
| `created_at` | timestamp | When the event occurred |

## Architecture

```
LLM Call
  → Ask::Instrumentation.instrument("chat.ask", payload)
    → ActiveSupport::Notifications publishes event
      → EventSubscriber persists to Ask::Event (AR)
      → Dashboard reads from Ask::Event via Metrics
      → Alert rules check metrics and fire notifications
```

## Development

```bash
git clone https://github.com/ask-rb/ask-monitoring.git
cd ask-monitoring
bundle install
bundle exec rake test
```

## License

MIT

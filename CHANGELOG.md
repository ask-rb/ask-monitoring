# Changelog

## [0.1.0] - 2026-06-21

### Added
- Event subscriber that persists `ask.*` events to ActiveRecord
- Cost model with pricing for 22+ models across OpenAI, Anthropic, Google, Mistral, Cohere, Bedrock
- Custom pricing registration (`Ask::Monitoring::Cost.register`)
- Metrics calculators: Cost, Throughput, ErrorCount, ResponseTime (p50/p95/p99)
- Slack alert channel with webhook delivery
- Alert rules engine with configurable conditions and channels
- Dashboard controller with time/provider/model filters and JSON metrics endpoint
- **Real-time dashboard via Hotwire Turbo**: auto-refresh every 30s, smooth updates via Turbo Frames (no ActionCable/Redis needed)
- Rails engine with auto-subscribe and migration loading
- Database migration for `ask_events` table with indexed columns
- Install generator (`rails generate ask:monitoring:install`)
- Test suite: 17 tests, 109 assertions
- README with installation, dashboard tour, cost configuration, alerting guide

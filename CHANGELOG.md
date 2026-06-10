# Changelog

## [0.1.0] - Unreleased

### Added
- Event subscriber that persists `ask.*` events to ActiveRecord
- Cost model with pricing for 22+ models across OpenAI, Anthropic, Google, Mistral, Cohere, Bedrock
- Custom pricing registration (`Ask::Monitoring::Cost.register`)
- Metrics calculators: Cost, Throughput, ErrorCount, ResponseTime (p50/p95/p99)
- Slack alert channel with webhook delivery
- Alert rules engine with configurable conditions and channels
- Dashboard controller with time/provder/model filters
- Rails engine with auto-subscribe via Railtie
- Database migration for `ask_events` table with indexed columns
- Install generator (`rails generate ask:monitoring:install`)
- Test suite: 17 tests, 109 assertions
- README with installation, dashboard tour, cost configuration, alerting guide

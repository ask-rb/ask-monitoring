require_relative "lib/ask/monitoring/version"

Gem::Specification.new do |spec|
  spec.name = "ask-monitoring"
  spec.version = Ask::Monitoring::VERSION
  spec.authors = ["Kaka Ruto"]
  spec.email = ["kaka@myrrlabs.com"]

  spec.summary = "LLM monitoring dashboard for Rails"
  spec.description = "Rails engine that provides real-time monitoring for LLM usage. " \
                     "Cost tracking, throughput metrics, error rates, response times. " \
                     "Slack alerts. Real-time updates via Hotwire Turbo. " \
                     "Works with any ask-rb provider via ask-instrumentation events."
  spec.homepage = "https://github.com/ask-rb/ask-monitoring"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 3.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "README.md", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "ask-instrumentation", ">= 0.1"
  spec.add_dependency "rails", ">= 7.1"
  spec.add_dependency "groupdate", "~> 6.0"
  spec.add_dependency "importmap-rails", "~> 2.0"
  spec.add_dependency "turbo-rails", "~> 2.0"

  spec.add_development_dependency "minitest", "~> 5.25"
  spec.add_development_dependency "rake", "~> 13.0"
end

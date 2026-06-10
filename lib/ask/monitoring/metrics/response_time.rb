module Ask
  module Monitoring
    module Metrics
      # Computes response time percentiles from +Ask::Event+ records.
      #
      # Supports p50, p95, p99 latency queries.
      class ResponseTime < Base
        # @return [Hash] Percentile data: { p50: Float, p95: Float, p99: Float }
        def percentiles
          durations = scope.pluck(:duration).compact
          return { p50: 0, p95: 0, p99: 0 } if durations.empty?

          sorted = durations.sort
          {
            p50: percentile(sorted, 50),
            p95: percentile(sorted, 95),
            p99: percentile(sorted, 99)
          }
        end

        alias as_chart_data percentiles

        private

        def percentile(sorted, p)
          return 0 if sorted.empty?
          index = ((p / 100.0) * (sorted.length - 1)).round
          sorted[index] * 1000.0 # convert seconds to ms
        end
      end
    end
  end
end

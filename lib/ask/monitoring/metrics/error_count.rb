module Ask
  module Monitoring
    module Metrics
      # Computes error count over time chart data.
      class ErrorCount < Base
        def as_chart_data
          scope
            .where.not(error: nil)
            .group_by_period(:hour, :created_at)
            .count
            .map { |date, value| { date: date, value: value } }
        end

        # @return [Float] Error rate as a decimal (0.0 – 1.0)
        def rate
          total = scope.count
          return 0.0 if total.zero?
          scope.where.not(error: nil).count.to_f / total
        end
      end
    end
  end
end

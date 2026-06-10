module Ask
  module Monitoring
    module Metrics
      # Computes cost-over-time chart data from +Ask::Event+ records.
      #
      # Groups events by time period and sums the +cost+ column.
      # Requires +groupdate+ for time-series grouping.
      class Cost < Base
        # @return [Array<Hash>] Chart data points [{date: Time, value: Float}]
        def as_chart_data
          scope
            .group_by_period(:hour, :created_at)
            .sum(:cost)
            .map { |date, value| { date: date, value: value.to_f } }
        end
      end
    end
  end
end

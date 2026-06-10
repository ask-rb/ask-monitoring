module Ask
  module Monitoring
    module Metrics
      # Computes throughput (requests per minute) chart data.
      class Throughput < Base
        def as_chart_data
          scope
            .group_by_period(:hour, :created_at)
            .count
            .map { |date, value| { date: date, value: value } }
        end
      end
    end
  end
end

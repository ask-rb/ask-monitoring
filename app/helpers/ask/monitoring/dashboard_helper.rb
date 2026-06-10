module Ask
  module Monitoring
    module DashboardHelper
      def metric_chart_data(metric)
        metric.as_chart_data.to_json
      end
    end
  end
end

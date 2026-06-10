require "ask/monitoring/metrics/cost"
require "ask/monitoring/metrics/throughput"
require "ask/monitoring/metrics/error_count"
require "ask/monitoring/metrics/response_time"

module Ask
  module Monitoring
    class DashboardController < ::ApplicationController
      # When requested from a Turbo Frame, render only the frame content
      # (no layout) for efficient partial updates.
      layout -> { turbo_frame_request? ? false : "application" }

      def index
        @time_range  = parse_time_range
        @provider    = params[:provider]
        @model       = params[:model]

        base = Ask::Event.since(@time_range.begin)
        base = base.by_provider(@provider) if @provider.present?
        base = base.by_model(@model) if @model.present?

        @events            = base
        @cost_metric       = Metrics::Cost.new(base)
        @throughput_metric = Metrics::Throughput.new(base)
        @error_metric      = Metrics::ErrorCount.new(base)
        @response_metric   = Metrics::ResponseTime.new(base)

        # Must use same turbo_frame_tag ID from the view
      end

      def metrics
        base = Ask::Event.since(parse_time_range.begin)
        base = base.by_provider(params[:provider]) if params[:provider].present?
        base = base.by_model(params[:model]) if params[:model].present?

        render json: {
          cost:          Metrics::Cost.new(base).as_chart_data,
          throughput:    Metrics::Throughput.new(base).as_chart_data,
          error_count:   Metrics::ErrorCount.new(base).as_chart_data,
          error_rate:    Metrics::ErrorCount.new(base).rate,
          response_time: Metrics::ResponseTime.new(base).percentiles
        }
      end

      private

      def parse_time_range
        case params[:since]
        when "24h" then 24.hours.ago..Time.current
        when "7d"  then 7.days.ago..Time.current
        when "30d" then 30.days.ago..Time.current
        else 1.hour.ago..Time.current
        end
      end
    end
  end
end

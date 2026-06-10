module Ask
  module Monitoring
    module Channels
      # Slack alert channel.
      #
      # Delivers alerts via Slack Incoming Webhooks.
      #
      # @example
      #   channel = Ask::Monitoring::Channels::Slack.new(webhook_url: "https://hooks.slack.com/...")
      #   channel.deliver(alert)
      class Slack < Base
        # @param webhook_url [String] Slack Incoming Webhook URL
        def initialize(webhook_url:)
          @webhook_url = webhook_url
        end

        # Deliver an alert to Slack.
        #
        # @param alert [Hash] Alert hash with +:name+, +:message+, +:metrics+
        # @return [Boolean] Whether delivery succeeded
        def deliver(alert)
          require "net/http"
          require "uri"
          require "json"

          uri = URI.parse(@webhook_url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == "https"

          payload = {
            text: format_alert(alert),
            mrkdwn: true
          }

          request = Net::HTTP::Post.new(uri.request_uri,
            "Content-Type" => "application/json")
          request.body = JSON.generate(payload)

          response = http.request(request)
          response.code.to_i == 200
        end

        private

        def format_alert(alert)
          <<~MESSAGE.chomp
            🚨 *#{alert[:name]}*
            #{alert[:message]}
            Error rate: #{(alert.dig(:metrics, :error_rate) || 0) * 100}%
          MESSAGE
        end
      end
    end
  end
end

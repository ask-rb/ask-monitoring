module Ask
  module Monitoring
    # Subscribes to +Ask::Instrumentation+ events and persists them to the
    # database via the +Ask::Event+ model.
    #
    # Each event is stored with:
    # - name, provider, model, duration, token counts
    # - calculated cost via {Ask::Monitoring::Cost.for}
    # - error information (when present)
    # - metadata context from +Ask::Instrumentation.current_metadata+
    class EventSubscriber
      # Called by +ActiveSupport::Notifications+ for each matching event.
      #
      # @param event [ActiveSupport::Notifications::Event] The instrumentation event
      def call(event)
        payload = event.payload

        Ask::Event.create!(
          name:           event.name,
          provider:       payload[:provider],
          model:          payload[:model],
          duration:       event.duration,
          input_tokens:   payload[:input_tokens],
          output_tokens:  payload[:output_tokens],
          cost:           calculate_cost(payload),
          error:          payload[:error],
          metadata:       Ask::Instrumentation.current_metadata
        )
      rescue => e
        # Never let a persistence failure break the calling code.
        Rails.logger.warn("[ask-monitoring] Failed to persist event: #{e.message}")
      end

      private

      def calculate_cost(payload)
        model = [payload[:provider], payload[:model]].compact.join("/")
        return 0.0 if model.empty?

        Ask::Monitoring::Cost.for(model,
          tokens: {
            input:  payload[:input_tokens]  || 0,
            output: payload[:output_tokens] || 0
          }
        )
      end
    end
  end
end

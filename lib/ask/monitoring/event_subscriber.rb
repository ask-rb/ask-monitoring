module Ask
  module Monitoring
    class EventSubscriber
      def call(event)
        raise NotImplementedError, "Implement me — see GOAL.md for details"
      end
    end
  end
end

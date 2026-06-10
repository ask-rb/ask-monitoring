module Ask
  module Monitoring
    module Channels
      # Email alert channel (stub for v0.2.0).
      #
      # Full implementation planned for v0.2.0 release.
      class Email < Base
        def initialize(from: nil, to: nil)
          @from = from
          @to = to
        end

        def deliver(alert)
          raise NotImplementedError, "Email alerts coming in v0.2.0"
        end
      end
    end
  end
end

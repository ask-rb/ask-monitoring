module Ask
  module Monitoring
    module Channels
      class Base
        def deliver(alert)
          raise NotImplementedError
        end
      end
    end
  end
end

module Ask
  module Monitoring
    module Metrics
      class Base
        attr_reader :scope

        def initialize(scope)
          @scope = scope
        end

        def as_chart_data
          raise NotImplementedError
        end
      end
    end
  end
end

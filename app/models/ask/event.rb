module Ask
  class Event < ActiveRecord::Base
    self.table_name = "ask_events"

    scope :errors, -> { where.not(error: nil) }
    scope :by_provider, ->(provider) { where(provider: provider) }
    scope :by_model, ->(model) { where(model: model) }
    scope :since, ->(time) { where(created_at: time..) }
  end
end

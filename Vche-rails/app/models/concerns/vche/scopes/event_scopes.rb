module Vche::Scopes::EventScopes
  extend ActiveSupport::Concern

  included do
    # eager_load or joins is required because of merge, and we would want the event anyway
    scope :secret_event_or_over, -> { eager_load(:event).merge(Event.secret_or_over) }
  end
end

module Vche::Scopes::EventScopes
  extend ActiveSupport::Concern

  included do
    scope :secret_event_or_over, -> { joins(:event).merge(Event.secret_or_over) }
  end
end

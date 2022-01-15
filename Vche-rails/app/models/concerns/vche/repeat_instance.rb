module Vche::RepeatInstance
  extend ActiveSupport::Concern

  included do
    def assembled?(now = Time.current)
      (try(:assembled_at) || try(:opened_at) || started_at) < now
    end

    def opened?(now = Time.current)
      (try(:opened_at) || started_at) < now
    end

    def started?(now = Time.current)
      started_at < now
    end

    def ended?(now = Time.current)
      ended_at < now
    end

    def closed?(now = Time.current)
      (try(:closed_at) || ended_at) < now
    end
  end
end

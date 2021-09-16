module Enums::Resolution
  extend ActiveSupport::Concern

  included do
    enumerize :resolution, in: [
        :scheduled,
        :announced,
        :moved,
        :canceled,
        :ended,
        :completed
    ], default: :scheduled
  end
end

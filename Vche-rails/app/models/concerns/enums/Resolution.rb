module Enums::Resolution
  extend ActiveSupport::Concern

  included do
    enumerize :resolution, in: [
        :scheduled,
        :moved,
        :canceled,
        :completed
    ], default: :scheduled
  end
end

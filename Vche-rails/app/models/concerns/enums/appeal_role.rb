module Enums::AppealRole
  extend ActiveSupport::Concern

  included do
    enumerize :appeal_role, in: [
      :backstage,
      :audience,
      :personal
    ], default: :personal
  end
end

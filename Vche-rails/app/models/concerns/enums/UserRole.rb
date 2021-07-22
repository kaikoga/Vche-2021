module Enums::UserRole
  extend ActiveSupport::Concern

  included do
    enumerize :user_role, in: [
        :organizer,
        :staff,
        :user
    ], default: :user
  end
end

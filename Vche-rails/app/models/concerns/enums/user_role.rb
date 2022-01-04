module Enums::UserRole
  extend ActiveSupport::Concern

  included do
    enumerize :user_role, in: [
      :organizer,
      :staff,
      :user
    ], default: :user

    def become_organizer!
      update!(user_role: :organizer)
    end

    def become_staff!
      update!(user_role: :staff) unless user_role == 'organizer'
    end
  end
end

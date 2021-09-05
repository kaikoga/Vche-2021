module Enums::Role
  extend ActiveSupport::Concern

  included do
    enumerize :role, in: [
        :irrelevant,
        :owner,
        :instance_owner,
        :performer,
        :staff,
        :participant,
        :visitor,
        :viewer,
    ], default: :participant

    scope :owned, ->{ where(role: :owner) }
    scope :active, ->{ where.not(role: :irrelevant) }
    scope :backstage_member, ->{ where(role: [:owner, :instance_owner, :performer, :staff]) }
    scope :audience, ->{ where(role: [:participant, :visitor, :viewer]) }

    def role.backstage_options(new: false)
      if new
        options(only: [:instance_owner, :performer, :staff])
      else
        options(only: [:irrelevant, :instance_owner, :performer, :staff])
      end
    end
  end
end

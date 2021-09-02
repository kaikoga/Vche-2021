module Enums::Role
  extend ActiveSupport::Concern

  included do
    enumerize :role, in: [
        :owner,
        :instance_owner,
        :performer,
        :staff,
        :participant,
        :visitor,
        :viewer
    ], default: :participant

    scope :owned, ->{ where(role: :owner) }
    scope :backstage_member, ->{ where(role: [:owner, :instance_owner, :performer, :staff]) }
    scope :audience, ->{ where(role: [:participant, :visitor, :viewer]) }
  end
end

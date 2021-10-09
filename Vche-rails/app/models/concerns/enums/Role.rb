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
        # :visitor,
        # :viewer,
    ], default: :participant

    scope :owned, ->{ where(role: :owner) }
    scope :active, ->{ where.not(role: :irrelevant) }
    scope :backstage_member, ->{ where(role: [:owner, :instance_owner, :performer, :staff]) }
    scope :audience, ->{ where(role: [:participant, :visitor, :viewer]) }

    def self.backstage_role?(role)
      [:owner, :instance_owner, :performer, :staff].include?(role&.to_sym)
    end

    def self.audience_role?(role)
      [:participant, :visitor, :viewer].include?(role&.to_sym)
    end

    def role.backstage_options(owner: false)
      if owner
        options(only: [:owner, :instance_owner, :performer, :staff])
      else
        options(only: [:instance_owner, :performer, :staff])
      end
    end
  end
end

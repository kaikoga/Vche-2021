module Enums::Role
  extend ActiveSupport::Concern

  included do
    enumerize :role, in: [
        :owner,
        :instance_owner,
        :staff,
        :collaborator,
        :participant,
        :visitor,
        :viewer
    ], default: :participant
  end
end

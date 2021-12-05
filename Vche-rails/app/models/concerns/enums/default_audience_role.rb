module Enums::DefaultAudienceRole
  extend ActiveSupport::Concern

  included do
    # NOTE: sync with Enums::Role
    enumerize :default_audience_role, in: [
      :irrelevant,
      :owner,
      :instance_owner,
      :performer,
      :staff,
      :participant,
      :applicant
      # :visitor,
      # :viewer,
    ], default: :participant

    # FIXME: methods from Enums::Role
  end
end

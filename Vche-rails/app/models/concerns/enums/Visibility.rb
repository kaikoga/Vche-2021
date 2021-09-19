module Enums::Visibility
  extend ActiveSupport::Concern

  included do
    enumerize :visibility, in: [
        :public,
        :shared,
        :follow,
        :invite
    ], default: :invite

    scope :public_or_over, ->{ where(visibility: :public) }
    scope :shared_or_over, ->{ where(visibility: [:public, :shared]) }
    scope :follow_or_over, ->{ where.not(visibility: :invite) }
  end
end

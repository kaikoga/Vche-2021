module Enums::Visibility
  extend ActiveSupport::Concern

  included do
    enumerize :visibility, in: [
        :public,
        :shared,
        :follow,
        :invite
    ], default: :invite
  end
end

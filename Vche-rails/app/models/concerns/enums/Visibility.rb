module Enums::Visibility
  extend ActiveSupport::Concern

  included do
    enumerize :visibility, in: [
        :public,
        :guest,
        :follow,
        :invite
    ], default: :invite
  end
end

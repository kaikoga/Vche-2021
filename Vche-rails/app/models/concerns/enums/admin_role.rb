module Enums::AdminRole
  extend ActiveSupport::Concern

  included do
    enumerize :admin_role, in: [
      :admin,
      :none
    ], default: :none
  end
end

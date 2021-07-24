module Enums::Platform
  extend ActiveSupport::Concern

  included do
    enumerize :platform, in: [
        :vrchat_xp,
        :vrchat_pc,
        :vrchat_quest
    ]
  end
end

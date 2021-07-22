module Enums::Platform
  extend ActiveSupport::Concern

  included do
    enumerize :platform, in: [
        :vrchat
    ]
  end
end

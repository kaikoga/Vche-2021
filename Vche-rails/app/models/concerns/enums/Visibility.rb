module Enums::Visibility
  extend ActiveSupport::Concern

  included do
    enumerize :visibility, in: [
        :public,
        :shared,
        :invite,
        :secret
    ], default: :invite

    scope :public_or_over, ->{ where(visibility: :public) }
    scope :shared_or_over, ->{ where(visibility: [:public, :shared]) }
    scope :invite_or_over, ->{ where.not(visibility: :secret) }
    scope :secret_or_over, ->{ all }

    def visible?
      self.class.visible_visibility?(visibility)
    end

    def self.visible_visibility?(visibility)
      [:public, :shared].include?(visibility.to_sym)
    end
  end
end

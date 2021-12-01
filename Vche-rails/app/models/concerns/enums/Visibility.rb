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
      Enums::Visibility.visible_visibility?(visibility)
    end

    def visibility_emoji
      Enums::Visibility.visibility_emoji(visibility)
    end

    def visibility_emoji_text
      visibility_emoji + visibility_text
    end

    def self.visibility_emoji_text(visibility)
      Enums::Visibility.visibility_emoji(visibility) + self.visibility.find_value(visibility).text
    end

    def visibility.emoji_options
      options.map { |name, value| ["#{Enums::Visibility.visibility_emoji(value)}#{name}", value] }
    end
  end

  def visible_visibility?(visibility)
    [:public, :shared].include?(visibility.to_sym)
  end

  def visibility_emoji(visibility)
    visible_visibility?(visibility) ? '' : '🔒'
  end

  module_function :visible_visibility?, :visibility_emoji
end

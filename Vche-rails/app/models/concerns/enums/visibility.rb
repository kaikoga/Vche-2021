module Enums::Visibility
  extend ActiveSupport::Concern

  included do
    enumerize :visibility, in: [
      :public,
      :shared,
      :invite,
      :secret,
      :deleted
    ], default: :invite

    validates :visibility, unless: -> { validation_context == :destroy }, exclusion: { in: %w[deleted], message: 'をこの方法で削除済にすることはできません' }

    scope :public_or_over, -> { unscope(where: :visibility).where(visibility: :public) }
    scope :shared_or_over, -> { unscope(where: :visibility).where(visibility: [:public, :shared]) }
    scope :invite_or_over, -> { unscope(where: :visibility).where.not(visibility: [:secret, :deleted]) }
    scope :secret_or_over, -> { unscope(where: :visibility).where.not(visibility: :deleted) }

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
      options(except: [:deleted]).map { |name, value| ["#{Enums::Visibility.visibility_emoji(value)}#{name}", value] }
    end
  end

  def visible_visibility?(visibility)
    [:public, :shared].include?(visibility.to_sym)
  end

  def visibility_emoji(visibility)
    case visibility.to_sym
    when :public, :shared
      ''
    when :invite, :secret
      '🔒'
    else # :deleted
      '👻'
    end
  end

  module_function :visible_visibility?, :visibility_emoji
end

module Enums::Resolution
  extend ActiveSupport::Concern

  included do
    enumerize :resolution, in: [
      :information,
      :scheduled,
      :announced,
      :moved,
      :canceled,
      :ended,
      :completed,
    ], default: :information

    def resolution_emoji
      Enums::Resolution.resolution_emoji(resolution)
    end

    def resolution_emoji_text
      resolution_emoji + resolution_text
    end

    def self.resolution_emoji_text(resolution)
      Enums::Resolution.resolution_emoji(resolution) + self.resolution.find_value(resolution).text
    end

    def resolution.emoji_options(official:)
      kwargs = official ? {} : { except: [:scheduled, :announced] }
      options(**kwargs).map { |name, value| ["#{Enums::Resolution.resolution_emoji(value)}#{name}", value] }
    end

  end

  def resolution_emoji(resolution)
    case resolution.to_sym
    when :information
      '✏️'
    when :scheduled
      '🗒'
    when :announced
      '▶️'
    when :moved
      '⚠️'
    when :canceled
      '🛑️'
    when :ended
      '✅'
    when :completed
      '📗'
    else
      '❔'
    end
  end

  module_function :resolution_emoji
end

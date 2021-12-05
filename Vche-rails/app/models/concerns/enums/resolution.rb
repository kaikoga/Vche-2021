module Enums::Resolution
  extend ActiveSupport::Concern

  included do
    enumerize :resolution, in: [
      :information,
      :candidate,
      :scheduled,
      :announced,
      :moved,
      :canceled,
      :ended,
      :completed,
      :phantom
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

    def resolution.emoji_options(type)
      kwargs =
        case type
        when :official then { except: [:phantom] }
        when :unofficial then { except: [:scheduled, :announced, :phantom] }
        else { except: [:phantom] }
        end
      options(**kwargs).map { |name, value| ["#{Enums::Resolution.resolution_emoji(value)}#{name}", value] }
    end
  end

  def resolution_emoji(resolution)
    case resolution.to_sym
    when :information
      '✏️'
    when :candidate
      '❔'
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
    when :phantom
      '🗑'
    else
      '🤔'
    end
  end

  module_function :resolution_emoji
end

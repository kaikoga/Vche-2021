module Enums::PrimarySns
  extend ActiveSupport::Concern

  included do
    # NOTE: sync with Enums::DefaultAudienceRole
    enumerize :primary_sns, in: [
      :twitter,
    ], default: :twitter

    validates :primary_sns_name, length: { in: 1..31 }, allow_blank: true

    def primary_sns_url
      primary_sns_name.present? ? "https://twitter.com/#{primary_sns_name}" : ''
    end

    def primary_sns_url=(value)
      self.primary_sns = :twitter
      uri = Addressable::URI.parse(value)
      case uri.domain
      when nil
        self.primary_sns_name = uri.path.split("/")[0]
      when 'twitter.com'
        self.primary_sns_name = uri.path.split("/")[1]
      else
        self.primary_sns_name = uri.path.split("/")[1]
      end
    end

    def primary_twitter_name=(value)
      self.primary_sns = :twitter
      self.primary_sns_name = value
    end
  end
end

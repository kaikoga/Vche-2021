module Enums::PrimarySns
  extend ActiveSupport::Concern

  included do
    # NOTE: sync with Enums::DefaultAudienceRole
    enumerize :primary_sns, in: [
      :twitter,
    ], default: :twitter

    def primary_sns_url
      "https://twitter.com/#{primary_sns_name}"
    end

    def primary_sns_url=(value)
      self.primary_sns = :twitter
      self.primary_sns_name = value.split('/')[-1]
    end

    def primary_twitter_name=(value)
      self.primary_sns = :twitter
      self.primary_sns_name = value
    end
  end
end

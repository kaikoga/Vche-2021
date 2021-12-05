module Vche::AgreedAt
  extend ActiveSupport::Concern

  included do
    def agreed?(published_at)
      agreed_at && (agreed_at > published_at)
    end
  end
end

module Vche::Hashtag
  extend ActiveSupport::Concern

  included do
    validates :hashtag, length: { in: 0..63 }, allow_blank: true

    def hashtag_without_hash
      hashtag.sub('#', '')
    end

    before_validation do
      if self.hashtag
        case self.hashtag[0]
        when '#'
          # do nothing
        else
          self.hashtag = "##{self.hashtag}"
        end
      end
    end
  end
end

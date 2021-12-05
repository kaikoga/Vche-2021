module Vche::Hashtag
  extend ActiveSupport::Concern

  included do
    validates :hashtag, length: { in: 0..63 }, allow_blank: true

    before_validation do
      if self.hashtag
        case self.hashtag[0]
        when '#'
        else
          self.hashtag = "##{self.hashtag}"
        end
      end
    end
  end
end

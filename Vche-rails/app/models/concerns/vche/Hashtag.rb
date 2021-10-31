module Vche::Hashtag
  extend ActiveSupport::Concern

  included do
    before_validation do
      case self.hashtag[0]
      when nil
      when '#'
      else
        self.hashtag = '#' + self.hashtag
      end
    end
  end
end

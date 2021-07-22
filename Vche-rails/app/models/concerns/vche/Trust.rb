module Vche::Trust
  extend ActiveSupport::Concern

  included do
    before_validation do
      self.trust ||= 0
    end
  end
end

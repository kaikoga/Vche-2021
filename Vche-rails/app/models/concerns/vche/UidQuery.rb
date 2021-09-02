module Vche::UidQuery
  extend ActiveSupport::Concern

  included do
    extend FriendlyId
    friendly_id :uid
  end
end

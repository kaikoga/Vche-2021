module Vche::Scopes::UserScopes
  extend ActiveSupport::Concern

  included do
    scope :secret_user_or_over, -> { joins(:user).merge(User.secret_or_over) }
  end
end

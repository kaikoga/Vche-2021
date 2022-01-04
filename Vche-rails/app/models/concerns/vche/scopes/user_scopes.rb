module Vche::Scopes::UserScopes
  extend ActiveSupport::Concern

  included do
    # eager_load or joins is required because of merge, and we would want the user anyway
    scope :secret_user_or_over, -> { eager_load(:user).merge(User.secret_or_over) }
  end
end

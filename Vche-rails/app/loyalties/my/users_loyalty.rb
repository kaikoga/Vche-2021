class My::UsersLoyalty < ApplicationLoyalty
  def delete?
    user.owned_events.empty?
  end
end

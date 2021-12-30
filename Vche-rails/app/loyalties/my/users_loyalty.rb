class My::UsersLoyalty < ApplicationLoyalty
  def destroy?
    user.owned_events.empty?
  end
end

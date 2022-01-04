class My::UsersLoyalty < ApplicationLoyalty
  def delete_form?
    true
  end

  def delete?
    user.owned_events.empty?
  end
end

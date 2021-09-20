class Events::OwnersLoyalty < ApplicationLoyalty
  def select?
    update?
  end

  def edit?
    update?
  end

  def update?
    LoyaltyTools.user_is_primary_source?(record, user)
  end
end

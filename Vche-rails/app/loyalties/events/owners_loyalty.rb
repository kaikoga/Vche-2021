class Events::OwnersLoyalty < ApplicationLoyalty
  def introduction?
    LoyaltyTools.user_is_source?(record, user) && !LoyaltyTools.event_has_owner?(record)
  end

  def edit?
    LoyaltyTools.user_is_owner?(record, user)
  end

  def update?
    LoyaltyTools.user_is_primary_source?(record, user)
  end
end

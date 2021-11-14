class Events::EventFollowRequestsLoyalty < ApplicationLoyalty
  def index?
    LoyaltyTools.user_is_backstage_member?(record, user)
  end

  def withdraw?
    LoyaltyTools.user_is_backstage_member?(record.event, user)
  end
end

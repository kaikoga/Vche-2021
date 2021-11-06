class My::EventFollowRequestsLoyalty < ApplicationLoyalty
  def index?
    true
  end

  def accept?
    record.user == user && !LoyaltyTools.user_is_backstage_member?(record.event, record.user)
  end

  def decline?
    record.user == user
  end
end

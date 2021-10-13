class Events::EventFollowsLoyalty < ApplicationLoyalty
  def index?
    LoyaltyTools.event_accessible?(record, user)
  end
end

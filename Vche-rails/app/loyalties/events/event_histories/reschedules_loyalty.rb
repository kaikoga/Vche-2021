class Events::EventHistories::ReschedulesLoyalty < ApplicationLoyalty
  def create?
    LoyaltyTools.user_is_source?(record.event, user) && !record.resolution.phantom?
  end
end

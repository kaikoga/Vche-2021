class Events::EventHistories::ReschedulesLoyalty < ApplicationLoyalty
  def create?
    LoyaltyTools.user_is_source?(record.event, user)
  end
end

class Events::EventHistories::ResolutionsLoyalty < ApplicationLoyalty
  def update?
    LoyaltyTools.user_is_source?(record.event, user)
  end
end

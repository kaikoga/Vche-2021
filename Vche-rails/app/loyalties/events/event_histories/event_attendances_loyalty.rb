class Events::EventHistories::EventAttendancesLoyalty < ApplicationLoyalty
  def index?
    LoyaltyTools.event_accessible?(record.event, user)
  end
end

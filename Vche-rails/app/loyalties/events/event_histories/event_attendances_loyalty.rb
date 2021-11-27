class Events::EventHistories::EventAttendancesLoyalty < ApplicationLoyalty
  def index?
    LoyaltyTools.event_accessible?(record.event, user) && !record.resolution.phantom?
  end
end

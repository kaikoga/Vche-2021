class Events::EventHistories::EventAttendancesLoyalty < ApplicationLoyalty
  def index?
    true
  end

  def create?
    true
  end

  def destroy?
    true
  end
end

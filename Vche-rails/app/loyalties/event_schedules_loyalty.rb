class EventSchedulesLoyalty < ApplicationLoyalty
  def index?
    true
  end

  def show?
    true
  end

  def create?
    LoyaltyTools.user_is_source?(record.event, user)
  end

  def update?
    LoyaltyTools.user_is_source?(record.event, user)
  end

  def destroy?
    LoyaltyTools.user_is_source?(record.event, user)
  end

  concerning :Model do
    def backstage?
      LoyaltyTools.user_is_backstage_member?(record.event, user)
    end
  end
end

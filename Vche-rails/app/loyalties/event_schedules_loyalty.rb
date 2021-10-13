class EventSchedulesLoyalty < ApplicationLoyalty
  def index?
    LoyaltyTools.event_accessible?(record, user)
  end

  def show?
    LoyaltyTools.event_accessible?(record.event, user)
  end

  def new?
    LoyaltyTools.user_is_source?(record, user)
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

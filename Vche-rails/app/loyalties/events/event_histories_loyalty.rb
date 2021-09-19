class Events::EventHistoriesLoyalty < ApplicationLoyalty
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

  def attend?
    !user.attending_event?(record)
  end

  def unattend?
    user.attending_event_as_audience?(record)
  end

  def add_user?
    user.attending_event_as_backstage_member?(record)
  end

  def remove_user?
    user.attending_event_as_backstage_member?(record)
  end

  concerning :Model do
    def backstage?
      LoyaltyTools.user_is_backstage_member?(record.event, user)
    end
  end
end
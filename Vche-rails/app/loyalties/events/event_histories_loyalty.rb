class Events::EventHistoriesLoyalty < ApplicationLoyalty
  def index?
    true
  end

  def show?
    true
  end

  def info?
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
    LoyaltyTools.user_is_backstage_member?(record.event, user)
  end

  def change_user?
    LoyaltyTools.user_is_backstage_member?(record.event, user)
  end

  def remove_user?
    LoyaltyTools.user_is_backstage_member?(record.event, user)
  end

  def memory?
    user.attending_event?(record)
  end

  concerning :Model do
    def backstage?
      LoyaltyTools.user_is_backstage_member?(record.event, user)
    end
  end
end

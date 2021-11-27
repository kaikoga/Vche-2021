class Events::EventHistoriesLoyalty < ApplicationLoyalty
  def index?
    LoyaltyTools.event_accessible?(record, user)
  end

  def show?
    LoyaltyTools.event_accessible?(record.event, user)
  end

  def info?
    LoyaltyTools.event_accessible?(record.event, user) && !record.resolution.phantom?
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
    LoyaltyTools.user_is_source?(record.event, user) && record.persisted?
  end

  def attend?
    LoyaltyTools.event_accessible?(record.event, user) && !record.resolution.phantom? && user && !user.attending_event?(record)
  end

  def unattend?
    LoyaltyTools.event_accessible?(record.event, user) && !record.resolution.phantom? && user && user.attending_event_as_audience?(record)
  end

  def add_user?
    LoyaltyTools.user_is_backstage_member?(record.event, user) && !record.resolution.phantom? && LoyaltyTools.event_allow_backstage?(record.event)
  end

  def change_user?
    LoyaltyTools.user_is_backstage_member?(record.event, user) && !record.resolution.phantom? && LoyaltyTools.event_allow_backstage?(record.event)
  end

  def remove_user?
    LoyaltyTools.user_is_backstage_member?(record.event, user) && !record.resolution.phantom?
  end

  def memory?
    LoyaltyTools.event_accessible?(record.event, user) && !record.resolution.phantom? && user && user.attending_event?(record)
  end

  concerning :Model do
    def backstage?
      LoyaltyTools.user_is_backstage_member?(record.event, user)
    end
  end
end

class EventsLoyalty < ApplicationLoyalty
  def index?
    true
  end

  def show?
    LoyaltyTools.event_accessible?(record, user)
  end

  def info?
    LoyaltyTools.event_accessible?(record, user)
  end

  def select?
    true
  end

  def create?
    true
  end

  def update?
    LoyaltyTools.user_is_source?(record, user)
  end

  def follow?
    LoyaltyTools.event_accessible?(record, user) && user && !user.following_event?(record)
  end

  def unfollow?
    LoyaltyTools.event_accessible?(record, user) && user && user.following_event_as_audience?(record)
  end

  def add_user?
    LoyaltyTools.user_is_owner?(record, user) && LoyaltyTools.event_allow_backstage?(record)
  end

  def change_user?
    LoyaltyTools.user_is_owner?(record, user) && LoyaltyTools.event_allow_backstage?(record)
  end

  def remove_user?
    LoyaltyTools.user_is_owner?(record, user)
  end

  concerning :Model do
    def backstage?
      LoyaltyTools.user_is_backstage_member?(record, user)
    end
  end
end

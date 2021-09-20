class EventsLoyalty < ApplicationLoyalty
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    LoyaltyTools.user_is_source?(record, user)
  end

  def destroy?
    false
  end

  def follow?
    !user.following_event?(record)
  end

  def unfollow?
    user.following_event_as_audience?(record)
  end

  def add_user?
    LoyaltyTools.user_is_owner?(record, user)
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

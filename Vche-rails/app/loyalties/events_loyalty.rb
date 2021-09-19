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
    owners = record.owners
    owners.empty? || owners.include?(user)
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
    user.following_event_as_backstage_member?(record)
  end

  def remove_user?
    user.following_event_as_backstage_member?(record)
  end

  concerning :Model do
    def backstage?
      record.backstage_members.include?(user)
    end
  end
end

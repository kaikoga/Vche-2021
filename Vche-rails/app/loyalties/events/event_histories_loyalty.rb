class Events::EventHistoriesLoyalty < ApplicationLoyalty
  def index?
    true
  end

  def show?
    true
  end

  def create?
    owners = record.event.owners
    owners.empty? || owners.include?(user)
  end

  def update?
    owners = record.event.owners
    owners.empty? || owners.include?(user)
  end

  def destroy?
    owners = record.event.owners
    owners.empty? || owners.include?(user)
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
      record.event.backstage_members.include?(user)
    end
  end
end

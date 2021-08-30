class EventsLoyalty < ApplicationLoyalty
  def index?
    true
  end

  def show?
    true
  end

  def backstage?
    record.backstage_members.include?(user)
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
end
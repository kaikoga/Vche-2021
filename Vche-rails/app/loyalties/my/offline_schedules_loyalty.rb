class My::OfflineSchedulesLoyalty < ApplicationLoyalty
  def index?
    true
  end

  def show?
    record.user == user
  end

  def new?
    true
  end

  def create?
    record.user == user
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end
end

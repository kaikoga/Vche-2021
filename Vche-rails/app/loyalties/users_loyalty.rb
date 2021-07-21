class UsersLoyalty < ApplicationLoyalty
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
    user == record
  end

  def destroy?
    false
  end
end

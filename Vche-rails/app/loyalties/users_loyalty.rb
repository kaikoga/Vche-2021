class UsersLoyalty < ApplicationLoyalty
  def index?
    true
  end

  def show?
    LoyaltyTools.user_accessible?(record, user)
  end

  def info?
    LoyaltyTools.user_accessible?(record, user)
  end

  def events?
    LoyaltyTools.user_accessible?(record, user)
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

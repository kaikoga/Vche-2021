class UsersLoyalty < ApplicationLoyalty
  def index?
    Vche.env.local?
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
    !user
  end

  def update?
    user == record
  end

  def destroy?
    false
  end
end

class SessionsLoyalty < ApplicationLoyalty
  def new?
    LoyaltyTools.password_login?
  end

  def create?
    LoyaltyTools.password_login?
  end

  def destroy?
    true
  end

  def purge?
    true
  end
end

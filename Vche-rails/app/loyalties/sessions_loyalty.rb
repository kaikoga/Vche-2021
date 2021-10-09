class SessionsLoyalty < ApplicationLoyalty
  def new?
    true
  end

  def create?
    true
  end

  def destroy?
    true
  end

  def purge?
    true
  end
end

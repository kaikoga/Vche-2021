class Users::AccountsLoyalty < ApplicationLoyalty
  def index?
    true
  end

  def show?
    true
  end

  def info?
    true
  end

  def create?
    user == record.user
  end

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end
end

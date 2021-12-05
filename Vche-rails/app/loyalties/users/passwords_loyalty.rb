class Users::PasswordsLoyalty < ApplicationLoyalty
  def update?
    return false unless LoyaltyTools.password_login?

    user == record
  end
end

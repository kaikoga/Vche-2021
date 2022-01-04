class My::PasswordsLoyalty < ApplicationLoyalty
  def update?
    LoyaltyTools.password_login?
  end
end

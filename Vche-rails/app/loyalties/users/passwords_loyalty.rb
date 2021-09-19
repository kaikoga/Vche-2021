class Users::PasswordsLoyalty < ApplicationLoyalty
  def update?
    user == record
  end
end

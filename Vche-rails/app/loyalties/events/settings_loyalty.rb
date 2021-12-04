class Events::SettingsLoyalty < ApplicationLoyalty
  def show?
    LoyaltyTools.user_is_primary_source?(record, user)
  end
end

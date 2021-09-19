class Events::VisibilitiesLoyalty < ApplicationLoyalty
  def edit?
    LoyaltyTools.user_is_primary_source?(record, user)
  end

  def update?
    if record.owners.empty?
      edit? && record.event_audiences.empty?
    else
      edit? && record.event_audiences.where.not(user: record.created_user).empty?
    end
  end
end

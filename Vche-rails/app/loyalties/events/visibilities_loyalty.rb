class Events::VisibilitiesLoyalty < ApplicationLoyalty
  def edit?
    LoyaltyTools.user_is_primary_source?(record, user)
  end

  def update?
    if Rails.application.config.x.vche.allow_private_backstage
      if LoyaltyTools.event_has_owner?(record)
        edit? && record.event_audiences.empty?
      else
        edit? && record.event_audiences.where.not(user: record.created_user).empty?
      end
    else
      if LoyaltyTools.event_has_owner?(record)
        edit? && record.event_follows.where.not(role: :owner).empty?
      else
        edit? && record.event_follows.where.not(user: record.created_user).empty?
      end
    end
  end
end

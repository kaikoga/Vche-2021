class Events::VisibilitiesLoyalty < ApplicationLoyalty
  def show?
    LoyaltyTools.event_accessible?(record, user)
  end

  def edit?
    LoyaltyTools.user_is_primary_source?(record, user)
  end

  def update?
    if Rails.application.config.x.vche.allow_private_backstage
      if record.official?
        edit? && record.event_audiences.empty?
      else
        edit? && record.event_audiences.where.not(user: record.created_user).empty?
      end
    else
      if record.official?
        edit? && record.event_follows.where.not(role: :owner).empty?
      else
        edit? && record.event_follows.where.not(user: record.created_user).empty?
      end
    end
  end
end

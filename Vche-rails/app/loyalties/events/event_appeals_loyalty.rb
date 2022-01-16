class Events::EventAppealsLoyalty < ApplicationLoyalty
  def update?
    event, appeal_role =
      case record
      when Array
        record
      when EventAppeal
        [record.event, record.appeal_role]
      else
        return false
      end

    if appeal_role.to_s == 'personal'
      user
    else
      LoyaltyTools.user_is_backstage_member?(event, user)
    end
  end
end

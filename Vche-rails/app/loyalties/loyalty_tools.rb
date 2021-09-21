module LoyaltyTools
  module_function

  def event_has_owner?(event)
    event.owners.exists?
  end

  def event_has_backstage_member?(event)
    event.backstage_members.exists?
  end

  def user_is_owner?(event, user)
    event.owners.include?(user)
  end

  def user_is_backstage_member?(event, user)
    event.backstage_members.include?(user)
  end

  def user_is_creator?(event, user)
    event.created_user == user
  end

  def user_is_source?(event, user)
    event_has_backstage_member?(event) ? user_is_backstage_member?(event, user) : user_is_creator?(event, user)
  end

  def user_is_primary_source?(event, user)
    event_has_owner?(event) ? user_is_owner?(event, user) : user_is_source?(event, user)
  end
end

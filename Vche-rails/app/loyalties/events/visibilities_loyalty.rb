class Events::VisibilitiesLoyalty < ApplicationLoyalty
  def edit?
    owners = record.owners
    owners.empty? ? owners.include?(user) : record.created_user == user
  end

  def update?
    if record.owners.empty?
      edit? && record.event_audiences.empty?
    else
      edit? && record.event_audiences.where.not(user: record.created_user).empty?
    end
  end
end

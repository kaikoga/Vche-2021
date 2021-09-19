class Events::EventHistories::ResolutionsLoyalty < ApplicationLoyalty
  def update?
    owners = record.event.owners
    owners.empty? || owners.include?(user)
  end
end

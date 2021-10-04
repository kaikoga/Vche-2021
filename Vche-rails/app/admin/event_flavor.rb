# == Schema Information
#
# Table name: event_flavors
#
#  id         :bigint           not null, primary key
#  event_id   :bigint
#  flavor_id  :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_event_flavors_on_event_id                (event_id)
#  index_event_flavors_on_event_id_and_flavor_id  (event_id,flavor_id) UNIQUE
#  index_event_flavors_on_flavor_id               (flavor_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (flavor_id => flavors.id)
#
ActiveAdmin.register EventFlavor do
  menu parent: :master
end

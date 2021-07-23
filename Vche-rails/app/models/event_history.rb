# == Schema Information
#
# Table name: event_histories
#
#  id           :bigint           not null, primary key
#  uid          :string(255)
#  event_id     :bigint           not null
#  visibility   :string(255)
#  resolution   :string(255)
#  assembled_at :datetime
#  opened_at    :datetime
#  started_at   :datetime         not null
#  ended_at     :datetime         not null
#  closed_at    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_event_histories_on_event_id  (event_id)
#  index_event_histories_on_uid       (uid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
class EventHistory < ApplicationRecord
  include Vche::Uid

  include Enums::Visibility
  include Enums::Resolution

  belongs_to :event
end

# == Schema Information
#
# Table name: event_attendances
#
#  id         :bigint           not null, primary key
#  uid        :string(255)
#  user_id    :bigint           not null
#  event_id   :bigint           not null
#  started_at :datetime         not null
#  role       :string(255)
#  hashtag    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_event_attendances_on_event_id                             (event_id)
#  index_event_attendances_on_uid                                  (uid) UNIQUE
#  index_event_attendances_on_user_id                              (user_id)
#  index_event_attendances_on_user_id_and_event_id_and_started_at  (user_id,event_id,started_at) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (user_id => users.id)
#
class EventAttendance < ApplicationRecord
  include Vche::Uid

  include Enums::Role

  belongs_to :user
  belongs_to :event

  scope :for_event_history, ->(event_history) { where(event_id: event_history.event_id, started_at: event_history.started_at) }

  def for_event_history?(event_history)
    event_history.event_id == event_id && event_history.started_at == started_at
  end

  def find_or_build_history
    event.find_or_build_history(started_at)
  end
end

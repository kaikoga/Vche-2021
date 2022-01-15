# == Schema Information
#
# Table name: event_schedules
#
#  id              :bigint           not null, primary key
#  uid             :string(255)
#  event_id        :bigint           not null
#  assemble_at     :datetime
#  open_at         :datetime
#  start_at        :datetime         not null
#  end_at          :datetime         not null
#  close_at        :datetime
#  repeat          :string(255)
#  repeat_until    :datetime
#  created_user_id :bigint
#  updated_user_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_event_schedules_on_created_user_id  (created_user_id)
#  index_event_schedules_on_event_id         (event_id)
#  index_event_schedules_on_uid              (uid) UNIQUE
#  index_event_schedules_on_updated_user_id  (updated_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_user_id => users.id)
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (updated_user_id => users.id)
#
class EventSchedule < ApplicationRecord
  include Vche::Uid
  include Vche::UidQuery
  include Vche::EditorFields

  include Enums::Repeat

  validates :start_at, presence: true
  validates :end_at, presence: true

  belongs_to :event

  def recent_histories(dates)
    recent_instances(dates).map { |date| at_date(date) }
  end

  def next_history
    next_instance&.yield_self { |date| at_date(date) }
  end

  def at_date(date)
    date_options = { year: date.year, month: date.month, day: date.day }
    history_resolution =
      if Time.current > end_at.change(date_options)
        :ended
      elsif event.multiplicity.quantum?
        :candidate
      elsif event.official?
        :scheduled
      else
        :information
      end
    EventHistory.new(
      event: event,
      resolution: history_resolution,
      capacity: event.capacity,
      default_audience_role: event.default_audience_role,
      assembled_at: assemble_at&.change(date_options),
      opened_at: open_at&.change(date_options),
      started_at: start_at&.change(date_options),
      ended_at: end_at&.change(date_options),
      closed_at: close_at&.change(date_options),
      created_user_id: created_user_id,
      updated_user_id: updated_user_id
    )
  end
end

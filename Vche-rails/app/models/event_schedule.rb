# == Schema Information
#
# Table name: event_schedules
#
#  id              :bigint           not null, primary key
#  uid             :string(255)
#  event_id        :bigint           not null
#  visibility      :string(255)      not null
#  assemble_at     :datetime
#  open_at         :datetime
#  start_at        :datetime         not null
#  end_at          :datetime         not null
#  close_at        :datetime
#  repeat          :string(255)
#  resolution      :string(255)
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

  include Enums::Visibility
  include Enums::Repeat
  include Enums::Resolution

  belongs_to :event

  belongs_to :created_user, class_name: 'User'
  belongs_to :updated_user, class_name: 'User'

  def recent_schedule(dates)
    return [at_date(start_at)] if repeat == :oneshot

    dates.filter(&method(:valid_date?)).map{|date| at_date(date) }
  end

  def next_schedule
    return at_date(start_at) if repeat.to_sym == :oneshot
    start = Time.current.beginning_of_day
    (0...35).map { |i| start + i.days }.filter { |date| valid_date?(date) }.take(1).map { |date| at_date(date) }.first
  end

  private

  def valid_date?(date)
    return false if date < start_at.beginning_of_day
    case repeat.to_sym
    when :oneshot
      date.beginning_of_day == start_at.beginning_of_day
    when :every_day
      true
    when :every_week
      date.wday == start_at.wday
    when :every_other_week
      (date.beginning_of_day - start_at.beginning_of_day) % 14.days == 0
    when :first_week
      date.wday == start_at.wday && (1..7).cover?(date.day)
    when :second_week
      date.wday == start_at.wday && (8..14).cover?(date.day)
    when :third_week
      date.wday == start_at.wday && (15..21).cover?(date.day)
    when :fourth_week
      date.wday == start_at.wday && (22..28).cover?(date.day)
    when :fifth_week
      date.wday == start_at.wday && (29..31).cover?(date.day)
    when :last_week
      return false unless date.wday == start_at.wday
      end_of_month = date.end_of_month.day
      ((end_of_month - 6)..end_of_month).cover?(date.day)
    end
  end

  def at_date(date)
    date_options = { year: date.year, month: date.month, day: date.day }
    EventHistory.new(
      event: event,
      visibility: visibility,
      resolution: Time.current < end_at.change(date_options) ? :scheduled : :ended,
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

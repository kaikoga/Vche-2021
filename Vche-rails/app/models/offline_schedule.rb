# == Schema Information
#
# Table name: offline_schedules
#
#  id           :bigint           not null, primary key
#  uid          :string(255)
#  user_id      :bigint
#  name         :string(255)
#  start_at     :datetime         not null
#  end_at       :datetime         not null
#  repeat       :string(255)
#  repeat_until :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_offline_schedules_on_uid      (uid) UNIQUE
#  index_offline_schedules_on_user_id  (user_id)
#
class OfflineSchedule < ApplicationRecord
  include Vche::Uid
  include Vche::UidQuery

  include Enums::Repeat

  validates :name, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  belongs_to :user

  def recent_histories(dates)
    recent_instances(dates).map { |date| at_date(date) }
  end

  private

  def at_date(date)
    date_options = { year: date.year, month: date.month, day: date.day }
    history_resolution = Time.current > end_at.change(date_options) ? :ended : :information
    OfflineHistory.new(
      parent: self,
      name: name,
      resolution: history_resolution,
      started_at: start_at&.change(date_options),
      ended_at: end_at&.change(date_options)
    )
  end

  OfflineHistory = Struct.new(:parent, :name, :resolution, :started_at, :ended_at, keyword_init: true)
end

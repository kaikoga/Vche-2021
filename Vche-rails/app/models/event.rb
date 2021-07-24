# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  uid             :string(255)
#  name            :string(255)
#  fullname        :string(255)
#  description     :string(255)
#  organizer_name  :string(255)
#  primary_sns     :string(255)
#  info_url        :string(255)
#  hashtag         :string(255)
#  platform        :string(255)      not null
#  visibility      :string(255)      not null
#  taste           :string(255)
#  trust           :integer
#  created_user_id :bigint
#  updated_user_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_events_on_created_user_id  (created_user_id)
#  index_events_on_uid              (uid) UNIQUE
#  index_events_on_updated_user_id  (updated_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_user_id => users.id)
#  fk_rails_...  (updated_user_id => users.id)
#
class Event < ApplicationRecord
  include Vche::Uid
  include Vche::Trust

  include Enums::Platform
  include Enums::Visibility

  belongs_to :created_user, class_name: 'User'
  belongs_to :updated_user, class_name: 'User'

  has_many :event_schedules
  has_many :event_histories

  def calendar
    @calendar ||= scheduled
  end

  def scheduled
    @scheduled ||= event_schedules.map do |event_schedule|
      EventHistory.new(
          event: self,
          visibility: self.visibility,
          resolution: :scheduled,
          assembled_at: event_schedule.assemble_at,
          opened_at: event_schedule.open_at,
          started_at: event_schedule.start_at,
          ended_at: event_schedule.end_at,
          closed_at: event_schedule.close_at,
          )
    end.sort_by(&:started_at)
  end

  def next_schedule
    @next_schedule ||= scheduled.first
  end
end

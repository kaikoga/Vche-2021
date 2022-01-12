# == Schema Information
#
# Table name: events
#
#  id                    :bigint           not null, primary key
#  uid                   :string(255)
#  name                  :string(255)
#  fullname              :string(255)
#  description           :text(65535)
#  organizer_name        :string(255)
#  primary_sns           :string(255)
#  primary_sns_name      :string(255)
#  info_url              :string(255)
#  hashtag               :string(255)
#  platform_id           :bigint           not null
#  category_id           :bigint           not null
#  visibility            :string(255)      not null
#  taste                 :string(255)
#  capacity              :integer          not null
#  multiplicity          :string(255)
#  default_audience_role :string(255)      not null
#  trust                 :integer          not null
#  base_trust            :integer          not null
#  created_user_id       :bigint
#  updated_user_id       :bigint
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_events_on_category_id      (category_id)
#  index_events_on_created_user_id  (created_user_id)
#  index_events_on_platform_id      (platform_id)
#  index_events_on_uid              (uid) UNIQUE
#  index_events_on_updated_user_id  (updated_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (created_user_id => users.id)
#  fk_rails_...  (platform_id => platforms.id)
#  fk_rails_...  (updated_user_id => users.id)
#
require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @event = events(:default)
  end

  teardown do
  end

  test 'empty #next_schedule' do
    assert { @event.next_schedule.nil? }
  end

  test '#next_schedule before start_at' do
    @event.event_schedules.create!(start_at: '2022-01-11 22:00:00', end_at: '2022-01-11 23:00:00', repeat: :every_week)
    travel_to(Time.zone.parse('2022-01-11 21:00:00')) do
      assert { @event.next_schedule.started_at == Time.zone.parse('2022-01-11 22:00:00') }
    end
  end

  test '#next_schedule within start_at..end_at' do
    @event.event_schedules.create!(start_at: '2022-01-11 22:00:00', end_at: '2022-01-11 23:00:00', repeat: :every_week)
    travel_to(Time.zone.parse('2022-01-11 22:30:00')) do
      assert { @event.next_schedule.started_at == Time.zone.parse('2022-01-11 22:00:00') }
    end
  end

  test '#next_schedule after end_at' do
    @event.event_schedules.create!(start_at: '2022-01-11 22:00:00', end_at: '2022-01-11 23:00:00', repeat: :every_week)
    travel_to(Time.zone.parse('2022-01-11 23:00:00')) do
      assert { @event.next_schedule.started_at == Time.zone.parse('2022-01-18 22:00:00') }
    end
  end
end

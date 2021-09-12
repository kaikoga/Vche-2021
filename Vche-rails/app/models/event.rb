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
  OWNER_TRUST = 200000000
  STAFF_TRUST = 100000000

  include Vche::Uid
  include Vche::UidQuery
  include Vche::Trust

  include Enums::Platform
  include Enums::Visibility
  include Enums::Taste

  belongs_to :created_user, class_name: 'User'
  belongs_to :updated_user, class_name: 'User'

  has_many :event_flavors, dependent: :destroy
  has_many :flavors, through: :event_flavors
  accepts_nested_attributes_for :event_flavors, allow_destroy: true

  has_many :event_schedules
  has_many :event_histories

  has_many :event_follows, dependent: :destroy
  has_many :followers, through: :event_follows, source: :user

  has_many :event_owners, -> { owned }, class_name: 'EventFollow'
  has_many :owners, through: :event_owners, source: :user

  has_many :event_backstage_members, -> { backstage_member }, class_name: 'EventFollow'
  has_many :backstage_members, through: :event_backstage_members, source: :user

  has_many :event_audiences, -> { audience }, class_name: 'EventFollow'
  has_many :audiences, through: :event_audiences, source: :user

  has_many :event_attendances, dependent: :destroy

  before_validation :recalculate_trust

  def recalculate_trust
    trust = 0
    root_trust = 0
    event_follows.reload.each do |event_follow|
      t = event_follow.user.trust
      case
      when event_follow.role.to_sym == :owner
        t += OWNER_TRUST
      when EventFollow.backstage_role?(event_follow.role)
        t += STAFF_TRUST
      else
        # none
      end
      root_trust = [t, root_trust].max
      trust += 1
    end
    self.trust = root_trust + trust
  end

  def next_schedule
    @next_schedule ||= event_schedules.map do |event_schedule|
      EventHistory.new(
        event: self,
        visibility: event_schedule.visibility,
        resolution: :scheduled,
        assembled_at: event_schedule.assemble_at,
        opened_at: event_schedule.open_at,
        started_at: event_schedule.start_at,
        ended_at: event_schedule.end_at,
        closed_at: event_schedule.close_at,
        created_user_id: event_schedule.created_user_id,
        updated_user_id: event_schedule.updated_user_id
      )
    end.sort_by(&:started_at).first
  end

  def recent_schedule(recent_dates)
    event_schedules.flat_map { |schedule| schedule.recent_schedule(recent_dates) }.concat(event_histories)
      .index_by(&:started_at).values
  end

  def find_or_build_history(start_at)
    recent_schedule([start_at.beginning_of_day])
      .detect { |history| history.started_at == start_at} ||
    EventHistory.new(
      event: self,
      visibility: self.visibility,
      resolution: :canceled,
      started_at: start_at
    )
  end

  def main_flavor
    @main_flavor ||= flavors.first
  end

  def flavors=(slugs)
    flavors = Flavor.where(slug: slugs).all
    event_flavors.where.not(flavor: flavors).destroy_all
    flavors.each do |flavor|
      event_flavors.create_or_find_by(flavor: flavor)
    end

    flavor_tastes = flavors.map(&:taste)
    self.taste = Flavor.taste.values.reverse.detect { |taste| flavor_tastes.include?(taste) } || :general
  end
end

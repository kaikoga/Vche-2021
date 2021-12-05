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
class Event < ApplicationRecord
  OWNER_TRUST = 200000000
  STAFF_TRUST = 100000000

  include Vche::Uid
  include Vche::UidQuery
  include Vche::Hashtag
  include Vche::Trust
  include Vche::EditorFields

  include Enums::DefaultAudienceRole
  include Enums::Visibility
  include Enums::Taste
  include Enums::Multiplicity
  include Enums::PrimarySns

  validates :name, length: { in: 1..31 }
  validates :fullname, length: { in: 1..255 }, allow_blank: true
  validates :description, length: { in: 1..4095 }, allow_blank: true
  validates :organizer_name, length: { in: 1..63 }, allow_blank: true
  validates :info_url, length: { in: 1..255 }, allow_blank: true
  validates :capacity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :platform
  belongs_to :category
  has_many :event_flavors, dependent: :destroy
  has_many :flavors, through: :event_flavors
  accepts_nested_attributes_for :event_flavors, allow_destroy: true

  has_many :event_schedules, dependent: :destroy
  has_many :event_histories, dependent: :destroy

  has_many :event_follow_requests, dependent: :destroy
  has_many :follow_requesters, through: :event_follow_requests, source: :user

  has_many :event_follows, dependent: :destroy
  has_many :followers, through: :event_follows, source: :user

  has_many :event_owners, -> { owned }, class_name: 'EventFollow'
  has_many :owners, through: :event_owners, source: :user

  has_many :event_backstage_members, -> { backstage_member }, class_name: 'EventFollow'
  has_many :backstage_members, through: :event_backstage_members, source: :user

  has_many :event_audiences, -> { audience }, class_name: 'EventFollow'
  has_many :audiences, through: :event_audiences, source: :user

  has_many :event_attendances, dependent: :destroy

  has_many :event_memories, dependent: :destroy

  before_validation :recalculate_capacity

  before_validation :recalculate_trust

  # scope :with_category_param, ->(category_param) { category_param.present? ? where(category: Category.find_by(slug: category_param)) : all }
  scope :with_category_param, ->(category_param) { category_param.present? ? joins(:category).where('categories.slug': category_param) : all }

  scope :with_trust_param, ->(trust_param) do
    case trust_param.to_s
    when 'owner'
      where('trust >= ?', OWNER_TRUST)
    when 'trusted'
      where('trust >= ?', 3)
    else
      all
    end
  end

  def recalculate_trust
    trust = 0
    root_trust = 0
    event_follows.eager_load(:user).reload.each do |event_follow|
      next unless user = event_follow.user

      t = user.trust
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
    self.trust = base_trust + root_trust + trust
  end

  def next_schedule
    @next_schedule ||= event_schedules.map(&:next_schedule).compact.sort_by(&:started_at).first
  end

  def recent_schedule(recent_dates)
    event_schedules.flat_map { |schedule| schedule.recent_schedule(recent_dates) }.concat(event_histories)
      .index_by(&:started_at).values
  end

  def scheduled_at?(time)
    event_schedules.flat_map { |schedule| schedule.recent_schedule([time]) }.any? { |history| history.started_at == time }
  end

  def find_or_build_history(start_at)
    recent_schedule([start_at.beginning_of_day])
      .detect { |history| history.started_at == start_at} ||
      EventHistory.new(
        event: self,
        resolution: :phantom,
        capacity: 0,
        started_at: start_at,
        ended_at: start_at,
      )
  end

  def flavors=(slugs)
    flavors = Flavor.where(slug: slugs).all
    event_flavors.where.not(flavor: flavors).destroy_all
    flavors.each do |flavor|
      event_flavors.create_or_find_by(flavor: flavor)
    end

    flavor_tastes = flavors.map(&:taste)
    self.taste = Flavor.taste.values.reverse.detect { |taste| flavor_tastes.include?(taste) } || :welcome
  end

  def owner=(user)
    event_owners.update_all(role: :staff)
    event_follows.create_or_find_by!(user: user).update!(role: :owner)
  end

  def official?
    owners.exists?
  end

  private

  def recalculate_capacity
    self.capacity ||= 0
  end
end

# == Schema Information
#
# Table name: users
#
#  id                           :bigint           not null, primary key
#  email                        :string(255)      not null
#  uid                          :string(255)      not null
#  display_name                 :string(255)
#  primary_sns                  :string(255)
#  profile                      :string(255)
#  visibility                   :string(255)      not null
#  trust                        :integer          not null
#  user_role                    :string(255)      not null
#  admin_role                   :string(255)      not null
#  agreed_at                    :datetime
#  crypted_password             :string(255)
#  salt                         :string(255)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  remember_me_token            :string(255)
#  remember_me_token_expires_at :datetime
#  last_login_at                :datetime
#  last_logout_at               :datetime
#  last_activity_at             :datetime
#  last_login_from_ip_address   :string(255)
#  invalidate_sessions_before   :datetime
#
# Indexes
#
#  index_users_on_email                                (email) UNIQUE
#  index_users_on_last_logout_at_and_last_activity_at  (last_logout_at,last_activity_at)
#  index_users_on_remember_me_token                    (remember_me_token)
#
class User < ApplicationRecord
  include Vche::Uid
  include Vche::UidQuery
  include Vche::Trust

  include Enums::Visibility
  include Enums::UserRole
  include Enums::AdminRole

  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  has_many :accounts
  has_many :event_memories

  has_many :created_events, class_name: 'Event', foreign_key: :created_user_id
  has_many :updated_events, class_name: 'Event', foreign_key: :updated_user_id
  has_many :created_event_schedules, class_name: 'EventSchedule', foreign_key: :created_user_id
  has_many :updated_event_schedules, class_name: 'EventSchedule', foreign_key: :updated_user_id
  has_many :created_event_histories, class_name: 'EventHistory', foreign_key: :created_user_id
  has_many :updated_event_histories, class_name: 'EventHistory', foreign_key: :updated_user_id

  has_many :event_follows, dependent: :destroy
  has_many :following_events, through: :event_follows, source: :event

  has_many :owned_follows, -> { owned }, class_name: 'EventFollow'
  has_many :owned_events, through: :owned_follows, source: :event
  has_many :backstage_follows, -> { backstage_member }, class_name: 'EventFollow'
  has_many :backstage_events, through: :backstage_follows, source: :event
  has_many :audience_follows, -> { audience }, class_name: 'EventFollow'
  has_many :audience_events, through: :audience_follows, source: :event

  has_many :event_attendances, dependent: :destroy

  has_many :feedbacks, dependent: :destroy

  def following_event?(event)
    event_follows.where(event: event).first&.role
  end

  def following_event_as_audience?(event)
    event_follows.audience.where(event: event).first&.role
  end

  def following_event_as_backstage_member?(event)
    event_follows.backstage_member.where(event: event).first&.role
  end

  def attending_event?(event_history)
    event_attendances.for_event_history(event_history).first&.role
  end

  def attending_event_as_audience?(event_history)
    event_attendances.audience.for_event_history(event_history).first&.role
  end

  def attending_event_as_backstage_member?(event_history)
    event_attendances.backstage_member.for_event_history(event_history).first&.role
  end
end

# == Schema Information
#
# Table name: users
#
#  id                           :bigint           not null, primary key
#  email                        :string(255)      not null
#  uid                          :string(255)      not null
#  display_name                 :string(255)
#  primary_sns                  :string(255)
#  visibility                   :string(255)      not null
#  trust                        :integer          not null
#  user_role                    :string(255)      not null
#  admin_role                   :string(255)      not null
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
#
# Indexes
#
#  index_users_on_email                                (email) UNIQUE
#  index_users_on_last_logout_at_and_last_activity_at  (last_logout_at,last_activity_at)
#  index_users_on_remember_me_token                    (remember_me_token)
#
class User < ApplicationRecord
  include Vche::Uid
  include Vche::Trust

  include Enums::Visibility
  include Enums::UserRole
  include Enums::AdminRole

  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  has_many :created_events, class_name: 'Event', foreign_key: :created_user_id
  has_many :updated_events, class_name: 'Event', foreign_key: :updated_user_id
  has_many :created_event_schedules, class_name: 'EventSchedule', foreign_key: :created_user_id
  has_many :updated_event_schedules, class_name: 'EventSchedule', foreign_key: :updated_user_id
end

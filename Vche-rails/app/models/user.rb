# == Schema Information
#
# Table name: users
#
#  id                           :bigint           not null, primary key
#  crypted_password             :string(255)
#  email                        :string(255)      not null
#  last_activity_at             :datetime
#  last_login_at                :datetime
#  last_login_from_ip_address   :string(255)
#  last_logout_at               :datetime
#  remember_me_token            :string(255)
#  remember_me_token_expires_at :datetime
#  salt                         :string(255)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_users_on_email                                (email) UNIQUE
#  index_users_on_last_logout_at_and_last_activity_at  (last_logout_at,last_activity_at)
#  index_users_on_remember_me_token                    (remember_me_token)
#
class User < ApplicationRecord
  authenticates_with_sorcery!
end

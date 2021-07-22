# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  uid          :string(255)
#  name         :string(255)
#  display_name :string(255)
#  platform     :string(255)
#  url          :string(255)
#  user_id      :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_accounts_on_uid      (uid) UNIQUE
#  index_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Account < ApplicationRecord
  include Vche::Uid

  include Enums::Platform
end

# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  uid             :string(255)
#  name            :string(255)
#  hashtag         :string(255)
#  platform        :string(255)
#  visibility      :string(255)
#  trust           :integer
#  created_user_id :bigint
#  updated_user_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_events_on_created_user_id  (created_user_id)
#  index_events_on_hashtag          (hashtag) UNIQUE
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
end

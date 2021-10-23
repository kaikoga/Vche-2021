# == Schema Information
#
# Table name: events
#
#  id                    :bigint           not null, primary key
#  uid                   :string(255)
#  name                  :string(255)
#  fullname              :string(255)
#  description           :string(255)
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
#  default_audience_role :string(255)      not null
#  trust                 :integer
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
require "test_helper"

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

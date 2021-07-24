# == Schema Information
#
# Table name: event_histories
#
#  id              :bigint           not null, primary key
#  uid             :string(255)
#  event_id        :bigint           not null
#  visibility      :string(255)      not null
#  resolution      :string(255)      not null
#  assembled_at    :datetime
#  opened_at       :datetime
#  started_at      :datetime         not null
#  ended_at        :datetime         not null
#  closed_at       :datetime
#  created_user_id :bigint
#  updated_user_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_event_histories_on_created_user_id          (created_user_id)
#  index_event_histories_on_event_id                 (event_id)
#  index_event_histories_on_event_id_and_started_at  (event_id,started_at) UNIQUE
#  index_event_histories_on_uid                      (uid) UNIQUE
#  index_event_histories_on_updated_user_id          (updated_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_user_id => users.id)
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (updated_user_id => users.id)
#
class EventHistory < ApplicationRecord
  include Vche::Uid

  include Enums::Visibility
  include Enums::Resolution

  belongs_to :event

  belongs_to :created_user, class_name: 'User'
  belongs_to :updated_user, class_name: 'User'

  delegate :trust, :hashtag, to: :event

  def trust_unique_key
    hashtag ? [hashtag, started_at] : []
  end
end

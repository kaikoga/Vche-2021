# == Schema Information
#
# Table name: event_follow_request_archives
#
#  id          :bigint           not null, primary key
#  user_id     :bigint           not null
#  event_id    :bigint           not null
#  approver_id :bigint           not null
#  role        :string(255)      not null
#  started_at  :datetime
#  message     :string(255)      not null
#  action      :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_event_follow_request_archives_on_approver_id  (approver_id)
#  index_event_follow_request_archives_on_event_id     (event_id)
#  index_event_follow_request_archives_on_user_id      (user_id)
#
class EventFollowRequestArchive < ApplicationRecord
  include Enums::Role

  belongs_to :user
  belongs_to :event
end

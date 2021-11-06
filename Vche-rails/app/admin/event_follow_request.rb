# == Schema Information
#
# Table name: event_follow_requests
#
#  id          :bigint           not null, primary key
#  user_id     :bigint           not null
#  event_id    :bigint           not null
#  approver_id :bigint           not null
#  role        :string(255)      not null
#  message     :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_event_follow_requests_on_approver_id  (approver_id)
#  index_event_follow_requests_on_event_id     (event_id)
#  index_event_follow_requests_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (approver_id => users.id)
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (user_id => users.id)
#
ActiveAdmin.register EventFollowRequest do
  menu parent: :user
end

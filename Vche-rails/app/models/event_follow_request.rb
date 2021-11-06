# == Schema Information
#
# Table name: event_follow_requests
#
#  id          :bigint           not null, primary key
#  user_id     :bigint           not null
#  event_id    :bigint           not null
#  approver_id :bigint           not null
#  role        :string(255)      not null
#  started_at  :datetime
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
class EventFollowRequest < ApplicationRecord
  include Enums::Role

  validates :role, exclusion: { in: %w(owner irrelevant), message: "の参加方法ではフォロー申請できません" }

  belongs_to :user
  belongs_to :event
  belongs_to :approver, class_name: 'User'

  def find_or_build_history
    event.find_or_build_history(started_at) if started_at
  end

  def accept
    if started_at
      Operations::EventHistory::UpdateUserRole.new(event_history: find_or_build_history, user: user, role: role).perform
    else
      Operations::Event::UpdateUserRole.new(event: event, user: user, role: role).perform
    end
    archive(action: 'accept')
  rescue Operations::Event::UpdateUserRole::UserIsOwner
    archive(action: 'already_owner')
  end

  def decline
    archive(action: 'decline')
  end

  private

  def archive(**options)
    EventFollowRequestArchive.create(**attributes.except('id', 'updated_at'), **options)
    destroy!
  end
end

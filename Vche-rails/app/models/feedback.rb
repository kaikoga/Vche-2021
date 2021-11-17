# == Schema Information
#
# Table name: feedbacks
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  user_uid    :string(255)
#  title       :text(65535)      not null
#  body        :text(65535)      not null
#  resolved_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_feedbacks_on_user_id  (user_id)
#
class Feedback < ApplicationRecord
  belongs_to :user, optional: true

  validates :title, length: { in: 1..255 }
  validates :body, length: { in: 1..4095 }

  scope :unresolved, ->{ where(resolved_at: nil) }
end

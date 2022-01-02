# == Schema Information
#
# Table name: event_memories
#
#  id           :bigint           not null, primary key
#  uid          :string(255)
#  user_id      :bigint           not null
#  event_id     :bigint           not null
#  started_at   :datetime         not null
#  published_at :datetime         not null
#  hashtag      :string(255)
#  body         :text(65535)      not null
#  urls         :json             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_event_memories_on_event_id                  (event_id)
#  index_event_memories_on_published_at              (published_at)
#  index_event_memories_on_uid                       (uid) UNIQUE
#  index_event_memories_on_user_id                   (user_id)
#  index_event_memories_on_user_id_and_published_at  (user_id,published_at)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (user_id => users.id)
#
class EventMemory < ApplicationRecord
  include Vche::Uid
  include Vche::UidQuery
  include Vche::Hashtag

  belongs_to :user, -> { secret_or_over }, optional: true, inverse_of: :event_memories
  belongs_to :event, -> { secret_or_over }, optional: true, inverse_of: :event_memories

  validates :started_at, presence: true
  validates :published_at, presence: true
  validates :body, length: { in: 0..4095 }, allow_blank: true
  validates :urls, length: { in: 0..4095 }, allow_blank: true

  scope :for_event_history, ->(event_history) { where(event_id: event_history.event_id, started_at: event_history.started_at) }
  scope :recent, -> { order(published_at: :desc).limit(5) }

  before_validation :update_published_at
  before_validation :default_urls

  def started_at_to_s
    started_at.strftime('%Y%m%d%H%M%S')
  end

  private

  def default_urls
    self.urls ||= []
  end

  def update_published_at
    self.published_at = Time.current
  end
end

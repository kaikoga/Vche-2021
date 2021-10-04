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
ActiveAdmin.register EventMemory do
  menu parent: :event

  index do
    selectable_column
    id_column
    column :uid
    column :user
    column :event
    column :started_at
    column :published_at
    column :hashtag
    column :created_at
    column :updated_at
    actions
  end
end

# == Schema Information
#
# Table name: event_appeals
#
#  id              :bigint           not null, primary key
#  uid             :string(255)
#  event_id        :bigint           not null
#  user_id         :bigint
#  appeal_role     :string(255)
#  available       :boolean          not null
#  message         :text(65535)
#  message_before  :text(65535)
#  message_after   :text(65535)
#  created_user_id :bigint
#  updated_user_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_event_appeals_on_created_user_id  (created_user_id)
#  index_event_appeals_on_event_id         (event_id)
#  index_event_appeals_on_uid              (uid) UNIQUE
#  index_event_appeals_on_updated_user_id  (updated_user_id)
#  index_event_appeals_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_user_id => users.id)
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (updated_user_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
ActiveAdmin.register EventAppeal do
  menu parent: :event

  index do
    selectable_column
    id_column
    column :uid
    column :event
    column :user
    column :available
    column :created_user
    column :updated_user
    column :created_at
    column :updated_at
    actions
  end
end

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
ActiveAdmin.register Feedback do
  menu parent: :support

  index do
    selectable_column
    id_column
    column :title
    column :user
    column :user_uid
    column :resolved_at
    actions
  end
end

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

  member_action :resolve_now do
    resource.update!(resolved_at: Time.current)
    redirect_to admin_feedback_path(resource)
  end

  member_action :unresolve_now do
    resource.update!(resolved_at: nil)
    redirect_to admin_feedback_path(resource)
  end

  action_item :resolve_now, only: [:show, :edit] do
    link_to 'Resolve now', resolve_now_admin_feedback_path(resource)
  end

  action_item :unresolve_now, only: [:show, :edit] do
    link_to 'Unresolve now', unresolve_now_admin_feedback_path(resource)
  end

  permit_params :resolved_at
end

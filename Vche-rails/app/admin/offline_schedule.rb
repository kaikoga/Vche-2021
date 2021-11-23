# == Schema Information
#
# Table name: offline_schedules
#
#  id           :bigint           not null, primary key
#  uid          :string(255)
#  user_id      :bigint
#  name         :string(255)
#  start_at     :datetime         not null
#  end_at       :datetime         not null
#  repeat       :string(255)
#  repeat_until :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_offline_schedules_on_uid      (uid) UNIQUE
#  index_offline_schedules_on_user_id  (user_id)
#
ActiveAdmin.register OfflineSchedule do
  menu parent: :user
end

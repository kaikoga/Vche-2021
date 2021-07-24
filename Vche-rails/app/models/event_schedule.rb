# == Schema Information
#
# Table name: event_schedules
#
#  id              :bigint           not null, primary key
#  uid             :string(255)
#  event_id        :bigint           not null
#  visibility      :string(255)      not null
#  assemble_at     :datetime
#  open_at         :datetime
#  start_at        :datetime         not null
#  end_at          :datetime         not null
#  close_at        :datetime
#  repeat          :json
#  repeat_until    :datetime
#  created_user_id :bigint
#  updated_user_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_event_schedules_on_created_user_id  (created_user_id)
#  index_event_schedules_on_event_id         (event_id)
#  index_event_schedules_on_uid              (uid) UNIQUE
#  index_event_schedules_on_updated_user_id  (updated_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_user_id => users.id)
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (updated_user_id => users.id)
#
class EventSchedule < ApplicationRecord
  include Vche::Uid

  include Enums::Visibility

  belongs_to :event

  belongs_to :created_user, class_name: 'User'
  belongs_to :updated_user, class_name: 'User'
end

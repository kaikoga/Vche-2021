# == Schema Information
#
# Table name: events
#
#  id                    :bigint           not null, primary key
#  uid                   :string(255)
#  name                  :string(255)
#  fullname              :string(255)
#  description           :text(65535)
#  organizer_name        :string(255)
#  primary_sns           :string(255)
#  primary_sns_name      :string(255)
#  info_url              :string(255)
#  hashtag               :string(255)
#  platform_id           :bigint           not null
#  category_id           :bigint           not null
#  visibility            :string(255)      not null
#  taste                 :string(255)
#  capacity              :integer          not null
#  default_audience_role :string(255)      not null
#  trust                 :integer          not null
#  base_trust            :integer          not null
#  created_user_id       :bigint
#  updated_user_id       :bigint
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_events_on_category_id      (category_id)
#  index_events_on_created_user_id  (created_user_id)
#  index_events_on_platform_id      (platform_id)
#  index_events_on_uid              (uid) UNIQUE
#  index_events_on_updated_user_id  (updated_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (created_user_id => users.id)
#  fk_rails_...  (platform_id => platforms.id)
#  fk_rails_...  (updated_user_id => users.id)
#
ActiveAdmin.register Event do
  menu parent: :event

  index do
    selectable_column
    id_column
    column :uid
    column :name
    column :organizer_name
    column :hashtag
    column :platform
    column :category
    column :visibility
    column :taste
    column :capacity
    column :trust
    column :created_user
    column :updated_user
    column :created_at
    column :updated_at
    actions
  end

  filter :uid
  filter :name
  filter :fullname
  filter :description
  filter :organizer_name
  filter :primary_sns
  filter :primary_sns_name
  filter :info_url
  filter :hashtag
  filter :platform, as: :select, collection: Platform.all
  filter :category, as: :select, collection: Category.all
  filter :visibility
  filter :taste
  filter :capacity
  filter :default_audience_role
  filter :trust
end

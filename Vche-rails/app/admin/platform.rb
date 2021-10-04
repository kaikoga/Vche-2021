# == Schema Information
#
# Table name: platforms
#
#  id         :bigint           not null, primary key
#  slug       :string(255)
#  name       :string(255)
#  available  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_platforms_on_name  (name) UNIQUE
#  index_platforms_on_slug  (slug) UNIQUE
#
ActiveAdmin.register Platform do
  menu parent: :master
end

# == Schema Information
#
# Table name: flavors
#
#  id         :bigint           not null, primary key
#  emoji      :string(255)
#  slug       :string(255)
#  name       :string(255)
#  taste      :string(255)
#  available  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_flavors_on_emoji  (emoji) UNIQUE
#  index_flavors_on_name   (name) UNIQUE
#  index_flavors_on_slug   (slug) UNIQUE
#
ActiveAdmin.register Flavor do
  menu parent: :master
end

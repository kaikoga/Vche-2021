# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  emoji      :string(255)
#  slug       :string(255)
#  name       :string(255)
#  available  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_emoji  (emoji) UNIQUE
#  index_categories_on_name   (name) UNIQUE
#  index_categories_on_slug   (slug) UNIQUE
#
ActiveAdmin.register Category do
  menu parent: :master
end

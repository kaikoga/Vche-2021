# == Schema Information
#
# Table name: agreements
#
#  id           :bigint           not null, primary key
#  slug         :string(255)      not null
#  body         :text(65535)      not null
#  published_at :text(65535)      not null
#  effective_at :text(65535)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
ActiveAdmin.register Agreement do
  menu parent: :master
end
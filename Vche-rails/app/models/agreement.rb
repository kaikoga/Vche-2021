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
class Agreement < ApplicationRecord
  def self.modified_at
    self.order(published_at: :desc).limit(1).pluck(:published_at).first
  end
end
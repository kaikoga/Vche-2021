# == Schema Information
#
# Table name: agreements
#
#  id           :bigint           not null, primary key
#  slug         :string(255)      not null
#  title        :text(65535)      not null
#  body         :text(65535)      not null
#  published_at :datetime         not null
#  effective_at :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Agreement < ApplicationRecord
  scope :recent, -> { where('published_at < ?', Time.current).order(published_at: :desc) }

  def self.by_slug(slug)
    self.recent.where(slug: slug).first
  end

  def self.modified_at
    self.recent.pick(:published_at)
  end
end

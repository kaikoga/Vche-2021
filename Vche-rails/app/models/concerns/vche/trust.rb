module Vche::Trust
  extend ActiveSupport::Concern

  included do
    before_validation do
      self.trust ||= 0
      self.base_trust ||= 0
    end
  end

  def self.filter_trusted(collection)
    collection.group_by(&:trust_unique_key).flat_map { |k, group| k.blank? ? group : [group.max_by(&:trust)] }
  end
end

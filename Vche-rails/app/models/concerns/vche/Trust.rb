module Vche::Trust
  extend ActiveSupport::Concern

  included do
    before_validation do
      self.trust ||= 0
    end
  end

  def self.filter_trusted(collection)
    collection.group_by { |record| record.trust_unique_key }.flat_map { |k, group| k.blank? ? group : [group.sort_by(&:trust).last] }
  end
end

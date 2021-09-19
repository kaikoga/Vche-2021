module Enums::Taste
  extend ActiveSupport::Concern

  included do
    enumerize :taste, in: [
      :welcome,
      :accessible,
      :restricted,
      :isolated,
      :hidden
    ], default: :hidden

    scope :welcome, ->{ where(taste: :welcome) }
    scope :accessible_or_over, ->{ where(taste: [:welcome, :accessible]) }
    scope :restricted_or_over, ->{ where(taste: [:welcome, :accessible, :restricted]) }
    scope :with_taste_param, ->(taste_param) {
      case taste_param
      when 'welcome'
        welcome
      when 'accessible'
        accessible_or_over
      when 'restricted'
        restricted_or_over
      when 'isolated'
        where(taste: :isolated)
      when 'all'
        where.not(taste: :hidden)
      else
        accessible_or_over
      end
    }
  end

  SELECT_OPTIONS = ['unselected', 'welcome', 'accessible', 'restricted', 'isolated', 'all'].freeze
  def select_options
    SELECT_OPTIONS.map do |v|
      [I18n.t(v, scope: 'enumerize.defaults.taste'), v == 'unselected' ? '' : v]
    end
  end
  module_function :select_options
end

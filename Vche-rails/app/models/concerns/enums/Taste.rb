module Enums::Taste
  extend ActiveSupport::Concern

  included do
    enumerize :taste, in: [
      :general,
      :private,
      :restricted,
      :mature,
      :hidden
    ], default: :hidden

    scope :general, ->{ where(taste: :general) }
    scope :general_or_private, ->{ where(taste: [:general, :private]) }
  end
end

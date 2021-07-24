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
  end
end

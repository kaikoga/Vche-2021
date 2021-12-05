module Enums::Multiplicity
  extend ActiveSupport::Concern

  included do
    enumerize :multiplicity, in: [
      :single,
      :multiple,
      :quantum
    ], default: :single
  end
end

module Enums::Repeat
  extend ActiveSupport::Concern

  included do
    enumerize :repeat, in: [
        :oneshot,
        :every_day,
        :every_week,
        :every_other_week,
        :first_week,
        :second_week,
        :third_week,
        :fourth_week,
        :fifth_week,
        :last_week
    ], default: :oneshot
  end
end

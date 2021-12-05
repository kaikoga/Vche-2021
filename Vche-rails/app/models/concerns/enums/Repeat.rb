module Enums::Repeat
  extend ActiveSupport::Concern

  included do
    enumerize :repeat, in: [
      :oneshot,
      :some_day,
      :every_day,
      :every_week,
      :every_other_week,
      :first_week,
      :second_week,
      :third_week,
      :fourth_week,
      :fifth_week,
      :odd_week,
      :even_week,
      :last_week
    ], default: :every_day

    def recent_instances(dates)
      return [start_at] if repeat == :oneshot

      dates.filter(&method(:instance_at_date?))
    end

    def next_instance
      return start_at if repeat.to_sym == :oneshot

      start = Time.current.beginning_of_day
      (0...35).map { |i| start + i.days }.filter { |date| instance_at_date?(date) }.take(1).first
    end

    private

    def instance_at_date?(date)
      return false if date < start_at.beginning_of_day

      case repeat.to_sym
      when :oneshot
        date.beginning_of_day == start_at.beginning_of_day
      when :some_day, :every_day
        true
      when :every_week
        date.wday == start_at.wday
      when :every_other_week
        (date.beginning_of_day - start_at.beginning_of_day) % 14.days == 0
      when :first_week
        date.wday == start_at.wday && ((date.day + 6) / 7) == 1
      when :second_week
        date.wday == start_at.wday && ((date.day + 6) / 7) == 2
      when :third_week
        date.wday == start_at.wday && ((date.day + 6) / 7) == 3
      when :fourth_week
        date.wday == start_at.wday && ((date.day + 6) / 7) == 4
      when :fifth_week
        date.wday == start_at.wday && ((date.day + 6) / 7) == 5
      when :even_week
        date.wday == start_at.wday && ((date.day + 6) / 7).even?
      when :odd_week
        date.wday == start_at.wday && ((date.day + 6) / 7).odd?
      when :last_week
        return false unless date.wday == start_at.wday

        end_of_month = date.end_of_month.day
        ((end_of_month - 6)..end_of_month).cover?(date.day)
      end
    end
  end
end

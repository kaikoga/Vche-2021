class CalendarPresenter
  attr_reader :events, :events_by_date, :recent_dates

  def initialize(events, days: 28)
    @events = events.filter(&:next_schedule).sort_by(&:next_schedule)
    @events_by_date = @events.group_by { |event| event.next_schedule.started_at.beginning_of_day }
    beginning_of_week = Time.current.beginning_of_week(:sunday)
    @recent_dates = (0...days).map { |i| beginning_of_week + i.days }
  end

  def recent_events_by_date
    @recent_events_by_date ||= recent_dates.map { |date| [date, events_by_date[date] || []] }.to_h
  end
end

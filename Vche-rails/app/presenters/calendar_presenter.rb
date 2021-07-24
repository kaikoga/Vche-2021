class CalendarPresenter
  attr_reader :event_histories_by_date

  def initialize(events, days: 28)
    beginning_of_calendar = Time.current.beginning_of_week(:sunday)
    recent_dates = (0...days).map { |i| beginning_of_calendar + i.days }

    event_histories = events
                        .flat_map(&:event_schedules)
                        .flat_map { |schedule| schedule.recent_schedule(recent_dates) }
                        .sort_by(&:started_at)

    grouped_event_histories = event_histories.group_by { |history| history.started_at.beginning_of_day }

    @event_histories_by_date = recent_dates.map{ |date| [date, grouped_event_histories[date] || []] }.to_h
  end
end

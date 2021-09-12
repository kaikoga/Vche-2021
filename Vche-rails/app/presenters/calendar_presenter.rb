class CalendarPresenter
  attr_reader :cells_by_date, :prev_year, :next_year, :prev_month, :next_month, :year_and_month

  def initialize(events, user: nil, year: nil, month: nil, months: 0, days: 28)
    if events.respond_to?(:includes)
      events = events.includes(:event_schedules, :event_histories, :flavors)
    end

    if year && month
      @year_and_month = "#{year}/#{month}"
      @prev_year = (month == 1) ? year - 1 : year
      @next_year = (month == 12) ? year + 1 : year
      @prev_month = (month == 1) ? 12 : month - 1
      @next_month = (month == 12) ? 1 : month + 1
      beginning_of_calendar = Time.zone.local(year, month, 1, 0, 0, 0).beginning_of_month.beginning_of_week(:sunday)
    else
      @year_and_month = ''
      @prev_year = Time.current.year
      @next_year = Time.current.next_month.year
      @prev_month = Time.current.month
      @next_month = Time.current.next_month.month
      beginning_of_calendar = Time.current.beginning_of_week(:sunday)
    end
    days += ((beginning_of_calendar + months.months - beginning_of_calendar) / 1.week.to_f).ceil * 7
    recent_dates = (0...days).map { |i| beginning_of_calendar + i.days }

    # FIXME N+1
    event_histories = events.flat_map{ |event| event.recent_schedule(recent_dates) }

    event_histories.sort_by(&:started_at)

    grouped_event_histories = event_histories.group_by { |history| history.started_at.beginning_of_day }

    if user
      event_attendances_by_date = user.event_attendances
        .where(started_at: beginning_of_calendar...(beginning_of_calendar + days.days))
        .group_by { |ea| ea.started_at.beginning_of_day }
    else
      event_attendances_by_date = {}
    end

    @cells_by_date = recent_dates.each_with_object({}) do |date, h|
      trusted_histories = Vche::Trust.filter_trusted(grouped_event_histories[date] || [])
      h[date] = Cell.new(trusted_histories, event_attendances_by_date[date] || [])
    end
  end

  class Cell
    attr_reader :event_histories
    attr_reader :event_attendances

    def initialize(event_histories, event_attendances)
      @event_histories = event_histories
      @event_attendances = event_attendances
    end

    def attending?(event_history)
      event_attendances.detect { |ea| ea.event_id = event_history.event_id && ea.started_at == event_history.started_at }
    end
  end
end

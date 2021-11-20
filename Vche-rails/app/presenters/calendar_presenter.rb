class CalendarPresenter
  attr_reader :cells_by_date, :prev_year, :next_year, :prev_month, :next_month, :year_and_month

  def prev_date
    Time.zone.local(prev_year, prev_month)
  end

  def next_date
    Time.zone.local(next_year, next_month)
  end

  def prev_date_text
    prev_date.strftime('%Y/%m')
  end

  def next_date_text
    next_date.strftime('%Y/%m')
  end

  def prev_date_str
    prev_date.strftime('%Y%m%d')
  end

  def next_date_str
    next_date.strftime('%Y%m%d')
  end

  def initialize(events, user: nil, date: nil, months: 0, days: 28)
    if events.respond_to?(:includes)
      events = events.includes(:event_schedules, :event_histories, :flavors)
    end

    if date
      year, month = date.year, date.month
      @year_and_month = "#{year}/#{month}"
      @prev_year = (month == 1) ? year - 1 : year
      @next_year = (month == 12) ? year + 1 : year
      @prev_month = (month == 1) ? 12 : month - 1
      @next_month = (month == 12) ? 1 : month + 1
      beginning_of_calendar = Time.zone.local(year, month, 1, 0, 0, 0).beginning_of_month.beginning_of_week(:sunday)
      end_of_months = (Time.zone.local(year, month, 1, 0, 0, 0).beginning_of_month + months.months)
      days += ((end_of_months - beginning_of_calendar) / 1.week.to_f).ceil * 7
    else
      @year_and_month = ''
      @prev_year = Time.current.year
      @next_year = Time.current.next_month.year
      @prev_month = Time.current.month
      @next_month = Time.current.next_month.month
      beginning_of_calendar = Time.current.beginning_of_week(:sunday)
      end_of_months = beginning_of_calendar + months.months
      days += ((end_of_months - beginning_of_calendar) / 1.week.to_f).ceil * 7
    end
    recent_dates = (0...days).map { |i| beginning_of_calendar + i.days }

    # FIXME N+1
    event_histories = events.flat_map{ |event| event.recent_schedule(recent_dates) }

    event_histories.sort_by(&:started_at)

    event_histories_by_date = event_histories.group_by { |history| history.started_at.beginning_of_day }

    if user
      event_attendances_by_date = user.event_attendances
        .where(started_at: beginning_of_calendar...(beginning_of_calendar + days.days))
        .group_by { |ea| ea.started_at.beginning_of_day }
    else
      event_attendances_by_date = {}
    end

    @cells_by_date = recent_dates.each_with_object({}) do |d, h|
      event_histories_of_date = event_histories_by_date[d] || []
      event_attendances_of_date = event_attendances_by_date[d] || []
      trusted_histories = Vche::Trust.filter_trusted(event_histories_of_date)
      alien_histories = event_attendances_of_date.map { |a| event_histories_of_date.detect { |h| h.event_id == a.event_id } || a.find_or_build_history }.compact
      visible_histories = trusted_histories | alien_histories
      h[d] = Cell.new(visible_histories, event_attendances_of_date)
    end
  end

  class Cell
    attr_reader :event_histories
    attr_reader :event_attendances

    def initialize(event_histories, event_attendances)
      @event_histories = event_histories.sort_by(&:started_at)
      @event_attendances = event_attendances
    end

    def attending?(event_history)
      event_attendances.detect { |ea| ea.event_id = event_history.event_id && ea.started_at == event_history.started_at }
    end
  end
end

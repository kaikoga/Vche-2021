class CalendarPresenter
  attr_reader :cells_by_date, :prev_date, :next_date, :current_date, :current, :format

  BAR_POSITIONS = [0, 3, 6, 9, 12, 15, 18, 21, 24].freeze

  def options
    [:month, :week, :compact].map { |v| [I18n.t(v, scope: 'vche.calendar.calendar'), v] }
  end

  def current?
    @current
  end

  def per_months?
    @per_months
  end

  def prev_date_text
    prev_date.strftime(date_text_format)
  end

  def next_date_text
    next_date.strftime(date_text_format)
  end

  def current_date_text
    current? ? '' : current_date.strftime(date_text_format)
  end

  def prev_date_str
    prev_date.strftime('%Y%m%d')
  end

  def next_date_str
    next_date.strftime('%Y%m%d')
  end

  def initialize(events, current_user: nil, display_user: nil, date: nil, months: 0, days: 28, format: nil, candidate: false, offline: false)
    if events.respond_to?(:includes)
      events = events.includes(:event_schedules, :event_histories)
    end

    @per_months = months > 0 || days >= 28

    if date
      @current_date = date.beginning_of_day
      if per_months?
        @prev_date = date - 1.month
        @next_date = date + 1.month
      else
        @prev_date = date - 1.week
        @next_date = date + 1.week
      end
    else
      @current = true
      @current_date = Time.current.beginning_of_day
      if per_months?
        @prev_date = current_date.beginning_of_month
        @next_date = current_date.next_month.beginning_of_month
      else
        @prev_date = current_date.beginning_of_week(:sunday)
        @next_date = current_date.next_week(:sunday).beginning_of_week(:sunday)
      end
    end

    beginning_of_calendar = current_date.beginning_of_week(:sunday)
    if months > 0
      end_of_months = current_date + months.months
      days += ((end_of_months - beginning_of_calendar) / 1.week.to_f).ceil * 7
    end
    recent_dates = (0...days).map { |i| beginning_of_calendar + i.days }

    @format = format

    # FIXME: N+1
    event_histories = events.flat_map { |event| event.recent_histories(recent_dates) }

    unless candidate
      event_histories.reject! { |h| h.resolution.candidate? }
    end

    event_histories.sort_by(&:started_at)
    event_histories_by_date = event_histories.group_by { |history| history.started_at.beginning_of_day }

    event_attendances_by_date =
      if display_user
        # FIXME: Ideally we should also collect current_user.event_attendances
        display_user.event_attendances
          .joins(:event).merge(Event.secret_or_over)
          .where(started_at: beginning_of_calendar...(beginning_of_calendar + days.days))
          .group_by { |ea| ea.started_at.beginning_of_day }
      else
        {}
      end

    offline_histories_by_date =
      if display_user && offline
        display_user.offline_schedules
          .where(start_at: beginning_of_calendar...(beginning_of_calendar + days.days), repeat: :oneshot)
          .or(display_user.offline_schedules.where.not(repeat: :oneshot)) # FIXME: Awful SQL
          .flat_map { |os| os.recent_histories(recent_dates) }
          .group_by { |oh| oh.started_at.beginning_of_day }
      else
        {}
      end

    @cells_by_date = recent_dates.each_with_object({}) do |d, h|
      event_histories_of_date = event_histories_by_date[d] || []
      event_attendances_of_date = event_attendances_by_date[d] || []
      offline_histories_of_date = offline_histories_by_date[d] || []
      trusted_histories = Vche::Trust.filter_trusted(event_histories_of_date)
      alien_histories = event_attendances_of_date.map do |attendance|
        event_histories_of_date.detect { |history| attendance.for_event_history?(history) } || attendance.find_or_build_history
      end
      alien_histories.compact!
      visible_histories = trusted_histories | alien_histories
      h[d] = Cell.new(current_user, d, visible_histories, event_attendances_of_date, offline_histories_of_date)
    end
  end

  def bar_positions
    BAR_POSITIONS
  end

  def time_to_y(time)
    hour_to_y(time.hour, time.min)
  end

  def hour_to_y(hour, min = 0)
    hf = hour + min / 60.0
    return hf * 4 unless format == :compact

    case hour
    when (0...18)
      hf * 1.5
    else
      hf * 3 - 27
    end
  end

  def recent_events
    @recent_events ||=
      begin
        today = Time.current.beginning_of_day
        events = cells_by_date.values.reject { |cell| cell.date < today }
          .lazy
          .flat_map(&:events)
          .reject(&:offline?)
          .reject { |cell_event| cell_event.ended_at < Time.current }
        attending_events = events.filter(&:attending?).take(8)
        unattending_events = events.reject(&:attending?).take(3)
        events = attending_events + unattending_events
        events.take_while.with_index { |cell_event, i| i < 3 || cell_event.important? }
      end
  end

  class Cell
    attr_reader :date, :events

    def initialize(current_user, date, event_histories, event_attendances, offline_histories)
      @date = date
      @event_attendances = event_attendances
      initialize_events(current_user, event_histories, offline_histories)
    end

    private

    def initialize_events(current_user, event_histories, offline_histories)
      @events = []
      @events += event_histories.map { |event_history| CellEvent.from_event_history(current_user, event_history, attendance_for(event_history)) }
      @events += offline_histories.map { |offline_history| CellEvent.from_offline_history(current_user, offline_history) }
      @events.sort_by!(&:started_at)

      offset = 0
      overlap_end_at = date
      events.each do |event|
        offset = 0 if event.started_at >= overlap_end_at
        event.offset = offset
        offset += 1
        overlap_end_at = [overlap_end_at, event.ended_at].max
      end
    end

    def attendance_for(event_history)
      event_attendances.detect { |ea| ea.event_id == event_history.event_id && ea.started_at == event_history.started_at }
    end

    attr_reader :event_attendances, :offline_histories
  end

  class CellEvent
    attr_reader :event_history, :offline_history, :resolution, :masked, :name, :started_at, :ended_at
    attr_accessor :offset

    delegate :role, :role_text, to: :event_attendance, allow_nil: true
    alias_method :attending?, :role
    alias_method :offline?, :offline_history
    alias_method :masked?, :masked

    def initialize(current_user, event_history: nil, offline_history: nil, event_attendance: nil)
      history = event_history || offline_history
      @event_attendance = event_attendance
      @started_at = history.started_at
      @ended_at = history.ended_at || history.started_at
      @resolution = ended_at > Time.current ? :information : :ended
      @offset = 0

      if event_history
        @masked = !Events::EventHistoriesLoyalty.new(current_user, event_history).show?
        if masked?
          @name = '予定あり'
        else
          @event_history = event_history
          @name = event_history.event.name
          @resolution = event_history.resolution
        end
      else
        @offline_history = offline_history
        @name = offline_history.name
      end
    end

    def time_and_name
      "#{I18n.l(started_at, format: :hm)} #{name}"
    end

    def important?
      attending? || started_at < Time.current.end_of_day
    end

    def self.from_event_history(current_user, event_history, event_attendance)
      self.new(current_user, event_history: event_history, event_attendance: event_attendance)
    end

    def self.from_offline_history(current_user, offline_history)
      self.new(current_user, offline_history: offline_history)
    end

    private

    attr_reader :event_attendance
  end

  private

  def date_text_format
    per_months? ? '%Y/%m' : '%Y/%m/%d'
  end
end

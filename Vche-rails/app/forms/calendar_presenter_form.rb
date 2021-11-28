class CalendarPresenterForm
  attr_reader :scoped_events, :params, :filter, :paginate, :range_mode

  def initialize(scoped_events, params, filter: false, paginate: false)
    @scoped_events = scoped_events
    @params = params
    @filter = filter
    @paginate = paginate
  end

  def presenter(current_user: nil, display_user: nil, months: 1, candidate: false)
    date = params[:date] ? Time.zone.parse(params[:date]) : nil
    days = 0
    format = nil
    case params[:calendar]
    when 'week'
      months = 0
      days = 7
      format = :week
    when 'compact'
      months = 0
      days = 7
      format = :compact
    else
      format = :month
    end
    CalendarPresenter.new(events, current_user: current_user, display_user: display_user, date: date, months: months, days: days, format: format, candidate: candidate)
  end

  def events
    @events ||=
      begin
        events = scoped_events
        events = events.with_category_param(params[:category]).with_trust_param(params[:trust]).with_taste_param(params[:taste]) if filter
        events = events.page(params[:page]) if paginate
        events
      end
  end
end

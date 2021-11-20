class CalendarPresenterForm
  attr_reader :scoped_events, :params, :filter, :paginate, :range_mode

  def initialize(scoped_events, params, filter: false, paginate: false)
    @scoped_events = scoped_events
    @params = params
    @filter = filter
    @paginate = paginate
  end

  def presenter(user: nil, months: 1)
    date = params[:date] ? Time.zone.parse(params[:date]) : nil
    days = 0
    if params[:calendar] == 'week'
      months = 0
      days = 7
    end
    CalendarPresenter.new(events, user: user, date: date, months: months, days: days)
  end

  def events
    @events ||=
      begin
        events = scoped_events
        events = events.with_category_param(params[:category]).with_taste_param(params[:taste]) if filter
        events = events.page(params[:page]) if paginate
        events
      end
  end
end

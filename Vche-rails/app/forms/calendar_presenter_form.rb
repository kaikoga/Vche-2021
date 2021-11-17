class CalendarPresenterForm
  attr_reader :scoped_events, :params, :filter, :paginate

  def initialize(scoped_events, params, filter: false, paginate: false)
    @scoped_events = scoped_events
    @params = params
    @filter = filter
    @paginate = paginate
  end

  def presenter(user: nil, months: 1)
    year = params[:year]&.to_i
    month = params[:month]&.to_i
    CalendarPresenter.new(events, user: user, year: year, month: month, months: months, days: 0)
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

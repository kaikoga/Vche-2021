class CalendarController < ApplicationController
  skip_before_action :require_login

  def index
    @calendar = CalendarPresenter.new(Event.includes(:event_schedules, :event_histories).all, days: 140)
  end
end

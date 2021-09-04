class CalendarController < ApplicationController
  skip_before_action :require_login

  def index
    @calendar = CalendarPresenter.new(Event.all, days: 140)
  end
end

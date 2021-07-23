class CalendarController < ApplicationController
  skip_before_action :require_login

  def index
    @calendar = CalendarPresenter.new(Event.all)
  end
end

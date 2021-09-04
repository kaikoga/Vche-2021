class HomeController < ApplicationController
  def show
    @user = current_user
    @calendar = CalendarPresenter.new(current_user.following_events.includes(:event_schedules, :event_histories).all, days: 35)
  end
end

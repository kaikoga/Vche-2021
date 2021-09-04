class HomeController < ApplicationController
  def show
    @user = current_user
    @calendar = CalendarPresenter.new(current_user.following_events, days: 35)
  end
end

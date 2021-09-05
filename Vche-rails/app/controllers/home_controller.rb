class HomeController < ApplicationController
  def show
    @user = current_user
    @calendar = CalendarPresenter.new(@user.following_events, user: @user, days: 35)
  end
end

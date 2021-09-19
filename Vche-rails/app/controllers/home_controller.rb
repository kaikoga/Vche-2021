class HomeController < ApplicationController
  def show
    year = show_params[:year]&.to_i
    month = show_params[:month]&.to_i

    @user = current_user
    @calendar = CalendarPresenter.new(@user.following_events, user: @user, year: year, month: month, months: 1, days: 0)
  end

  def events
    @user = current_user
    @events = @user.events.page(params[:page])
  end

  private

  def show_params
    @show_params ||= params.permit(:year, :month)
  end
end

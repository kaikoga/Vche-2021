class HomeController < ApplicationController::Bootstrap
  def show
    authorize!
    @user = current_user
    @form = CalendarPresenterForm.new(@user.following_events, show_params)
    @calendar = @form.presenter(current_user: @user, display_user: @user, candidate: false, offline: true)
  end

  private

  def show_params
    @show_params ||= params.permit(:calendar, :date)
  end
end

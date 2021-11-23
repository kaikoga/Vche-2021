class HomeController < ApplicationController::Bootstrap
  def show
    authorize!
    @user = current_user
    form = CalendarPresenterForm.new(@user.following_events, show_params)
    @calendar = form.presenter(user: @user, candidate: true)
  end

  def events
    authorize!
    @user = current_user
    @backstage_events = @user.backstage_events
    @audience_events = @user.audience_events.page(params[:page])
  end

  private

  def show_params
    @show_params ||= params.permit(:calendar, :date)
  end
end

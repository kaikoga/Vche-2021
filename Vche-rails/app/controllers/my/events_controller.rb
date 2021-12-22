class My::EventsController < ApplicationController::Bootstrap
  def index
    authorize!
    @user = current_user
    @backstage_events = @user.backstage_events
    @audience_events = @user.audience_events.page(params[:page])
  end
end

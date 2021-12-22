class My::EventsController < ApplicationController::Bootstrap
  include MyResources

  def index
    authorize!
    @backstage_events = @user.backstage_events
    @audience_events = @user.audience_events.page(params[:page])
  end
end

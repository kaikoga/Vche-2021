class My::EventFollowRequestsController < ApplicationController::Bootstrap
  def index
    @user = current_user
    @event_follow_requests = @user.event_follow_requests.page(params[:page])
    authorize!
  end

  def accept
    @user = current_user
    @event = find_event
    @event_follow_request = @user.event_follow_requests.find_by!(event: @event)
    authorize! @event_follow_request
    @event_follow_request.accept
    redirect_to @event, notice: 'Accepted.'
  end

  def decline
    @user = current_user
    @event = find_event
    @event_follow_request = @user.event_follow_requests.find_by!(event: @event)
    authorize! @event_follow_request
    @event_follow_request.decline
    redirect_to @event, notice: 'Declined.'
  end

  private

  def find_event
    Event.friendly.find(params[:id])
  end
end

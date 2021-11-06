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
    if @event_follow_request.started_at
      redirect_to [@event, @event_follow_request.find_or_build_history], notice: 'Accepted.'
    else
      redirect_to @event, notice: 'Accepted.'
    end
  end

  def decline
    @user = current_user
    @event = find_event
    @event_follow_request = @user.event_follow_requests.find_by!(event: @event)
    authorize! @event_follow_request
    @event_follow_request.decline
    redirect_to my_event_follow_requests_url, notice: 'Declined.'
  end

  private

  def find_event
    Event.friendly.find(params[:id])
  end
end

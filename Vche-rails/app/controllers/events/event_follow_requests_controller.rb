class Events::EventFollowRequestsController < ApplicationController::Bootstrap
  before_action :find_parent_event

  def index
    authorize! @event
    @user = current_user
    @event_follow_requests = @event.event_follow_requests.active
  end

  def withdraw
    @event_follow_request = @event.event_follow_requests.active.find_by!(uid: params[:id])
    authorize! @event_follow_request
    @event_follow_request.withdraw
    redirect_to event_event_follow_requests_path(@event), notice: I18n.t('notice.events/event_follow_requests.withdraw.success')
  end

  private

  def find_parent_event
    @event = Event.friendly.find(params[:event_id])
  end
end

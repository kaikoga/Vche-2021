class My::EventFollowRequestsController < ApplicationController::Bootstrap
  def index
    @user = current_user
    @event_follow_requests = @user.event_follow_requests.active.page(params[:page])
    authorize!
  end

  def accept
    @user = current_user
    @event_follow_request = find_event_follow_request
    authorize! @event_follow_request
    @event_follow_request.accept
    if @event_follow_request.started_at
      redirect_to [@event_follow_request.event, @event_follow_request.find_or_build_history], notice: I18n.t('notice.my/event_follow_requests.accept.success')
    else
      redirect_to @event_follow_request.event, notice: I18n.t('notice.my/event_follow_requests.accept.success')
    end
  end

  def decline
    @user = current_user
    @event_follow_request = find_event_follow_request
    authorize! @event_follow_request
    @event_follow_request.decline
    redirect_to my_event_follow_requests_url, notice: I18n.t('notice.my/event_follow_requests.decline.success')
  end

  private

  def find_event_follow_request
    @user.event_follow_requests.active.find_by!(uid: params[:id])
  end
end

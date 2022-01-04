class Events::EventHistories::ReschedulesController < ApplicationController::Bootstrap
  before_action :find_parent_event
  before_action :find_parent_event_history

  def new
    authorize! @event_history
    @user = current_user
  end

  def create
    authorize! @event_history
    @new_event_history = Operations::EventHistory::Reschedule.new(event_history: @event_history, params: reschedule_params, user: current_user).perform!
    redirect_to [@event, @new_event_history], notice: I18n.t('notice.events/event_histories/reschedules.create.success')
  rescue Operations::EventHistory::Reschedule::Unchanged
    redirect_to [@event, @event_history], notice: I18n.t('notice.events/event_histories/reschedules.create.unchanged')
  end

  private

  def find_parent_event
    @event = Event.friendly.secret_or_over.find(params[:event_id])
  end

  def find_parent_event_history
    @event_history = @event.find_or_build_history(Time.zone.parse(params[:event_history_id]))
  end

  def reschedule_params
    params.require(:event_history).permit(
      :capacity,
      :assembled_at, :opened_at, :started_at, :ended_at, :closed_at
    )
  end
end

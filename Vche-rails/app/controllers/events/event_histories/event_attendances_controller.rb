class Events::EventHistories::EventAttendancesController < ApplicationController
  before_action :find_parent_event
  before_action :find_parent_event_history

  def index
    authorize! @event
  end

  private

  def find_parent_event
    @event = Event.friendly.find(params[:event_id])
  end

  def find_parent_event_history
    @event_history = @event.find_or_build_history(Time.zone.parse(params[:event_history_id]))
  end
end
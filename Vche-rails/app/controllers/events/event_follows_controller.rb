class Events::EventFollowsController < ApplicationController
  def index
    @event = find_parent_event
    authorize! @event
  end

  private

  def find_parent_event
    @event = Event.friendly.find(params[:event_id])
  end
end

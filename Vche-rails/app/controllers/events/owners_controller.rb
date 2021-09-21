class Events::OwnersController < ApplicationController
  before_action :find_parent_event

  def introduction
    authorize! @event
  end

  def edit
    authorize! @event
  end

  def update
    authorize! @event
    @event.owner = (User.find(update_params[:owner_id]))
    redirect_to @event, notice: 'Event owner was successfully updated.'
  end

  private

  def find_parent_event
    @event = Event.friendly.find(params[:event_id])
  end

  def update_params
    params.require(:event).permit(:owner_id)
  end
end

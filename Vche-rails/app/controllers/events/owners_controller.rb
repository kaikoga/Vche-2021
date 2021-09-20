class Events::OwnersController < ApplicationController
  before_action :find_parent_event

  def select
    authorize! @event
  end

  def edit
    authorize! @event
  end

  def update
    authorize! @event
    if false
      redirect_to @event, notice: 'Event owner was successfully updated.'
    else
      render :edit
    end
  end

  private

  def find_parent_event
    @event = Event.friendly.find(params[:event_id])
  end

  def update_params
    params.require(:event).permit(:owner_id)
  end
end

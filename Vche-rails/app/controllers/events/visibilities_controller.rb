class Events::VisibilitiesController < ApplicationController
  before_action :find_parent_event

  def edit
    authorize! @event
  end

  def update
    authorize! @event
    if @event.update(update_params)
      redirect_to @event, notice: 'Event visibility was successfully updated.'
    else
      render :edit
    end
  end

  private

  def find_parent_event
    @event = Event.friendly.find(params[:event_id])
  end

  def update_params
    params.require(:event).permit(:visibility)
  end
end

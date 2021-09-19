class Events::EventHistories::ResolutionsController < ApplicationController
  before_action :find_parent_event
  before_action :find_parent_event_history

  def edit
    authorize! @event_history
  end

  def update
    authorize! @event_history
    if @event_history.update(update_params)
      redirect_to [@event, @event_history], notice: 'Event resolution was successfully updated.'
    else
      render :edit
    end
  end

  private

  def find_parent_event
    @event = Event.friendly.find(params[:event_id])
  end

  def find_parent_event_history
    @event_history = @event.find_or_build_history(Time.zone.parse(params[:event_history_id]))
  end

  def update_params
    params.require(:event_history).permit(:resolution)
  end
end

class Events::OwnersController < ApplicationController::Bootstrap
  before_action :find_parent_event

  def introduction
    authorize! @event
    @user = current_user
  end

  def edit
    authorize! @event
    @user = current_user
  end

  def update
    authorize! @event
    @event.owner = (User.friendly.find(update_params[:owner_id]))
    redirect_to @event, notice: I18n.t('notice.events/owners.update.success')
  end

  private

  def find_parent_event
    @event = Event.friendly.find(params[:event_id])
  end

  def update_params
    params.require(:event).permit(:owner_id)
  end
end

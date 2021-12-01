class Events::VisibilitiesController < ApplicationController::Bootstrap
  before_action :find_parent_event

  def show
    authorize! @event
    @user = current_user
  end

  def edit
    authorize! @event
    @user = current_user
  end

  def update
    authorize! @event
    if @event.update(update_params)
      redirect_to @event, notice: I18n.t('notice.events/visibilities.update.success')
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

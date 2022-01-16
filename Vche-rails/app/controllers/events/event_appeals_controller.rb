class Events::EventAppealsController < ApplicationController::Bootstrap
  before_action :find_parent_event
  before_action :find_event_appeal

  def edit
    authorize! @event_appeal
    @user = current_user
  end

  def update
    authorize! @event_appeal
    @event_appeal.updated_user = current_user
    @event_appeal.assign_attributes(update_params)
    if @event_appeal.save!
      redirect_to @event, notice: I18n.t('notice.events/event_appeals.update.success')
    else
      render :edit
    end
  end

  private

  def find_parent_event
    @event = Event.friendly.secret_or_over.find(params[:event_id])
  end

  def find_event_appeal
    appeal_role = params[:id]
    @event_appeal = @event.find_or_initialize_event_appeal_for(current_user, appeal_role)
  end

  def update_params
    params.require(:event_appeal).permit(:available, :message, :message_before, :message_after)
  end
end

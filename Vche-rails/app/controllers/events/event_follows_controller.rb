class Events::EventFollowsController < ApplicationController
  before_action :find_parent_event

  def index
    authorize! @event
    @user = current_user
  end

  private

  def find_parent_event
    @event = Event.friendly.find(params[:event_id])
  end
end

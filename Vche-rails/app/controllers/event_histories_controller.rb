class EventHistoriesController < ApplicationController
  before_action :find_parent_event
  skip_before_action :require_login, only: [:index, :show]

  def index
    @event_histories = EventHistory.all
  end

  def show
    @event_history = find_event_history
  end

  def new
    @event_history = EventHistory.new
  end

  def edit
    @event_history = find_event_history
  end

  def create
    @event_history = @event.event_histories.build(event_history_params)
    @event_history.created_user = current_user
    @event_history.updated_user = current_user

    if @event_history.save
      redirect_to @event, notice: 'EventHistory was successfully created'
    else
      render :new
    end
  end

  def update
    @event_history = find_event_history
    @event_history.updated_user = current_user
    if @event_history.update(event_history_params)
      redirect_to @event, notice: 'EventHistory was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event_history = find_event_history
    @event_history.destroy
    redirect_to events_url, notice: 'EventHistory was successfully destroyed.'
  end

  private

  def find_parent_event
    @event = Event.find(params[:event_id])
  end

  def find_event_history
    EventHistory.find(params[:id])
  end

  def event_history_params
    p = params.require(:event_history).permit(:visibility, :assembled_at, :opened_at, :started_at, :ended_at, :closed_at, :resolution)
  end
end

class EventsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]

  def index
    @events = Event.all
  end

  def show
    @event = find_event
  end

  def new
    @event = Event.new
  end

  def edit
    @event = find_event
  end

  def create
    @event = Event.new(event_params)
    @event.created_user = current_user
    @event.updated_user = current_user
    @event.flavors = event_flavors_params

    if @event.save
      redirect_to :events, notice: 'Event was successfully created'
    else
      render :new
    end
  end

  def update
    @event = find_event
    @event.updated_user = current_user
    @event.flavors = event_flavors_params

    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event = find_event
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  private

  def find_event
    Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :name, :fullname,
      :description, :organizer_name, :primary_sns, :info_url,
      :hashtag, :platform, :visibility
    )
  end

  def event_flavors_params
    params.require(:event_flavors)
  end
end

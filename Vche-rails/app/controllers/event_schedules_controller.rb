class EventSchedulesController < ApplicationController
  before_action :find_parent_event
  skip_before_action :require_login, only: [:index, :show]

  def index
    @event_schedules = EventSchedule.all
  end

  def show
    @event_schedule = find_event_schedule
  end

  def new
    @event_schedule = EventSchedule.new
  end

  def edit
    @event_schedule = find_event_schedule
  end

  def create
    @event_schedule = @event.event_schedules.build(event_schedule_params)
    @event_schedule.created_user = current_user
    @event_schedule.updated_user = current_user

    if @event_schedule.save
      redirect_to :events, notice: 'EventSchedule was successfully created'
    else
      render :new
    end
  end

  def update
    @event_schedule = find_event_schedule
    @event_schedule.updated_user = current_user
    if @event_schedule.update(event_schedule_params)
      redirect_to @event, notice: 'EventSchedule was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event_schedule = find_event_schedule
    @event_schedule.destroy
    redirect_to events_url, notice: 'EventSchedule was successfully destroyed.'
  end

  private

  def find_parent_event
    @event = Event.find(params[:event_id])
  end

  def find_event_schedule
    EventSchedule.find(params[:id])
  end

  def event_schedule_params
    p = params.require(:event_schedule).permit(:visibility, :assemble_at, :open_at, :start_at, :end_at, :close_at, :repeat, :repeat_until)
  end
end

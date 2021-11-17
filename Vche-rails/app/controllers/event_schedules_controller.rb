class EventSchedulesController < ApplicationController::Bootstrap
  before_action :find_parent_event
  skip_before_action :require_login, only: [:index, :show]

  def index
    @event_schedules = @event.event_schedules
    authorize! @event
    @user = current_user
  end

  def show
    @event_schedule = find_event_schedule
    authorize! @event_schedule
    @user = current_user
  end

  def new
    authorize! @event
    @event_schedule = @event.event_schedules.build
  end

  def edit
    @event_schedule = find_event_schedule
    authorize! @event_schedule
  end

  def create
    @event_schedule = @event.event_schedules.build(event_schedule_params)
    authorize! @event_schedule
    @event_schedule.created_user = current_user
    @event_schedule.updated_user = current_user

    if @event_schedule.save
      redirect_to @event, notice: I18n.t('notice.event_schedules.create.success')
    else
      render :new
    end
  end

  def update
    @event_schedule = find_event_schedule
    authorize! @event_schedule
    @event_schedule.updated_user = current_user
    if @event_schedule.update(event_schedule_params)
      redirect_to @event, notice: I18n.t('notice.event_schedules.update.success')
    else
      render :edit
    end
  end

  def destroy
    @event_schedule = find_event_schedule
    authorize! @event_schedule
    @event_schedule.destroy
    redirect_to events_url, notice: I18n.t('notice.event_schedules.destroy.success')
  end

  private

  def find_parent_event
    @event = Event.friendly.find(params[:event_id])
  end

  def find_event_schedule
    @event.event_schedules.find_by(uid: params[:id])
  end

  def event_schedule_params
    p = params.require(:event_schedule).permit(:visibility, :assemble_at, :open_at, :start_at, :end_at, :close_at, :repeat, :repeat_until)
  end
end

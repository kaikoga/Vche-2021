class Events::EventHistoriesController < ApplicationController
  before_action :find_parent_event
  skip_before_action :require_login, only: [:index, :show]

  def index
    @event_histories = @event.event_histories.order(started_at: :desc).page(params[:page])
    @user = current_user
    authorize!
  end

  def show
    @event_history = find_event_history
    authorize! @event_history
    @user = current_user
  end

  def info
    @event_history = find_event_history
    authorize! @event_history
    @user = current_user
  end

  def at
    started_at = Time.zone.parse(params[:datetime])
    @event_history = @event.recent_schedule([started_at.beginning_of_day]).detect { |h| h.started_at = started_at }
    authorize! @event_history
    render :show
  end

  def new
    @event_history = EventHistory.new
  end

  def edit
    @event_history = find_event_history
  end

  def create
    @event_history = @event.event_histories.build(event_history_params)
    authorize! @event_history
    @event_history.created_user = current_user
    @event_history.updated_user = current_user

    if @event_history.save
      redirect_to event_event_history_path(@event, @event_history), notice: 'EventHistory was successfully created'
    else
      render :new
    end
  end

  def update
    @event_history = find_event_history
    authorize! @event_history
    @event_history.updated_user = current_user
    if @event_history.update(event_history_params)
      redirect_to event_event_history_path(@event, @event_history), notice: 'EventHistory was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event_history = find_event_history
    authorize! @event_history
    @event_history.destroy
    redirect_to events_url, notice: 'EventHistory was successfully destroyed.'
  end

  def attend
    @event_history = find_event_history
    authorize! @event_history

    role = current_user.following_event_as_backstage_member?(@event) || :participant
    if current_user.event_attendances.for_event_history(@event_history).create!(role: role)
      redirect_to event_event_history_path(@event, @event_history), notice: 'Attended.'
    else
      redirect_to event_event_history_path(@event, @event_history)
    end
  end

  def unattend
    @event_history = find_event_history
    authorize! @event_history

    if current_user.event_attendances.audience.for_event_history(@event_history).delete_all
      redirect_to event_event_history_path(@event, @event_history), notice: 'Unattended.'
    else
      redirect_to event_event_history_path(@event, @event_history)
    end
  end

  def add_user
    @event_history = find_event_history
    authorize! @event_history
    @user = find_user

    if @user.event_attendances.for_event_history(@event_history).create!(role: params[:role])
      redirect_to event_event_history_event_attendances_path(@event, @event_history), notice: 'Added User.'
    else
      redirect_to event_event_history_event_attendances_path(@event, @event_history)
    end
  end

  def change_user
    @event_history = find_event_history
    authorize! @event_history
    @user = find_user

    if @user.event_attendances.for_event_history(@event_history).update(role: params[:role])
      redirect_to event_event_history_event_attendances_path(@event, @event_history), notice: 'Changed User.'
    else
      redirect_to event_event_history_event_attendances_path(@event, @event_history)
    end
  end

  def remove_user
    @event_history = find_event_history
    authorize! @event_history
    @user = find_user

    if @user.event_attendances.for_event_history(@event_history).destroy_all
      redirect_to event_event_history_event_attendances_path(@event, @event_history), notice: 'Removed User.'
    else
      redirect_to event_event_history_event_attendances_path(@event, @event_history)
    end
  end

  private

  def find_user
    User.friendly.find(params[:user_id])
  end

  def find_parent_event
    @event = Event.friendly.find(params[:event_id])
  end

  def find_event_history
    @event.find_or_build_history(Time.zone.parse(params[:id]))
  end

  def event_history_params
    p = params.require(:event_history).permit(:visibility, :assembled_at, :opened_at, :started_at, :ended_at, :closed_at, :resolution)
  end
end

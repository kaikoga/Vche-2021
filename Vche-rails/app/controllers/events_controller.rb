class EventsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]

  def index
    @events = Event.page(params[:page])
  end

  def show
    @event = find_event
    @user = current_user

    @calendar = CalendarPresenter.new([@event], user: @user, days: 35)
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

    if @event.save
      @event.flavors = event_flavors_params
      @event.event_follows.create(user: current_user, role: :owner)
      redirect_to :events, notice: 'Event was successfully created'
    else
      render :new
    end
  end

  def update
    @event = find_event
    authorize! @event
    @event.updated_user = current_user

    if @event.update(**event_params, flavors: event_flavors_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event = find_event
    authorize! @event
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end


  def follow
    @event = find_event
    authorize! @event

    if current_user.event_follows.create!(event: @event, role: :participant)
      redirect_to @event, notice: 'Followed.'
    else
      redirect_to @event
    end
  end

  def unfollow
    @event = find_event
    authorize! @event

    if current_user.event_follows.audience.where(event: @event).delete_all
      redirect_to @event, notice: 'Unfollowed.'
    else
      redirect_to @event
    end
  end

  def add_user
    @event = find_event
    authorize! @event
    @user = find_user

    if @user.event_follows.create!(event: @event, role: :participant)
      redirect_to @event, notice: 'Added User.'
    else
      redirect_to @event
    end
  end

  def remove_user
    @event = find_event
    authorize! @event
    @user = find_user

    if @user.event_follows.where(event: @event).delete_all
      redirect_to @event, notice: 'Removed User.'
    else
      redirect_to @event
    end
  end

  private

  def find_user
    User.friendly.find(params[:user_id])
  end

  def find_event
    Event.friendly.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :name, :fullname,
      :description, :organizer_name, :primary_sns, :info_url,
      :hashtag, :platform, :visibility
    )
  end

  def event_flavors_params
    params['event_flavors'] || []
  end
end

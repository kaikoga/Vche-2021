class EventsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]

  def index
    @events = Event.public_or_over.with_category_param(params[:category]).with_taste_param(params[:taste]).page(params[:page])
  end

  def show
    @event = find_event
    @user = current_user

    year = show_params[:year]&.to_i
    month = show_params[:month]&.to_i
    @calendar = CalendarPresenter.new([@event], user: @user, year: year, month: month, months: 2, days: 0)
  end

  def select
  end

  def new
    @event = Event.new
    @role = params[:role] == 'owner' ? :owner : :participant

    if @role == :owner
      @event.organizer_name = current_user.display_name
      @event.primary_sns = "https://twitter.com/#{current_user.email}"
      @event.info_url = "https://twitter.com/#{current_user.email}"
      @event.visibility = :shared
    end
  end

  def edit
    @event = find_event
  end

  def create
    @event = Event.new(create_params)
    @event.created_user = current_user
    @event.updated_user = current_user
    role = params[:role] == 'owner' ? :owner : :participant

    if @event.save
      @event.flavors = event_flavors_params
      @event.event_follows.create(user: current_user, role: role)
      redirect_to :events, notice: 'Event was successfully created'
    else
      render :new
    end
  end

  def update
    @event = find_event
    authorize! @event
    @event.updated_user = current_user

    if @event.update(**update_params, flavors: event_flavors_params)
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

    if @user.event_follows.create!(event: @event, role: params[:role])
      redirect_to event_event_follows_url(@event), notice: 'Added User.'
    else
      redirect_to event_event_follows_url(@event)
    end
  end

  def remove_user
    @event = find_event
    authorize! @event
    @user = find_user

    if @event.owner_ids.include? @user.id
      redirect_to edit_event_owner_url(@event)
    elsif @user.event_follows.where(event: @event).delete_all
      redirect_to event_event_follows_url(@event), notice: 'Removed User.'
    else
      redirect_to event_event_follows_url(@event)
    end
  end

  private

  def find_user
    User.friendly.find(params[:user_id])
  end

  def find_event
    Event.friendly.find(params[:id])
  end

  def index_params
    params.permit(:taste)
  end

  def show_params
    params.permit(:year, :month)
  end

  def create_params
    params.require(:event).permit(
      :name, :fullname,
      :description, :organizer_name, :primary_sns, :info_url,
      :hashtag, :platform_id, :category_id, :visibility
    )
  end

  def update_params
    params.require(:event).permit(
      :name, :fullname,
      :description, :organizer_name, :primary_sns, :info_url,
      :hashtag, :platform_id, :category_id
    )
  end

  def event_flavors_params
    params['event_flavors'] || []
  end
end

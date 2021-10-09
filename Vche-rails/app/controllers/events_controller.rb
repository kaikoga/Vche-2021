class EventsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]

  def index
    @events = Event.public_or_over.with_category_param(params[:category]).with_taste_param(params[:taste]).page(params[:page])
    authorize!
  end

  def show
    @event = find_event
    @user = current_user
    authorize!

    year = show_params[:year]&.to_i
    month = show_params[:month]&.to_i
    @calendar = CalendarPresenter.new([@event], user: @user, year: year, month: month, months: 2, days: 0)
  end

  def info
    @event = find_event
    @user = current_user
    authorize!
  end

  def select
    authorize!
  end

  def new
    @event = Event.new
    @role = params[:role] == 'owner' ? :owner : :participant
    authorize! @event

    if @role == :owner
      @event.organizer_name = current_user.display_name
      @event.primary_sns = "https://twitter.com/#{current_user.email}"
      @event.info_url = "https://twitter.com/#{current_user.email}"
      @event.visibility = :shared
    end
  end

  def edit
    @event = find_event
    authorize! @event
  end

  def create
    @event = Event.new(create_params)
    @event.created_user = current_user
    @event.updated_user = current_user
    role = params[:role] == 'owner' ? :owner : :participant
    authorize! @event

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

    Operations::Event::UpdateUserFollow.new(event: @event, user: current_user, role: params[:role] || @event.default_audience_role).perform!
    redirect_to @event, notice: 'Followed.'
  rescue ActiveRecord::RecordInvalid
    redirect_to @event
  rescue Operations::Event::UpdateUserFollow::UserIsBackstage
    redirect_to @event
  end

  def unfollow
    @event = find_event
    authorize! @event

    Operations::Event::UpdateUserFollow.new(event: @event, user: current_user, role: nil).perform!
    redirect_to @event, notice: 'Unfollowed.'
  rescue ActiveRecord::RecordInvalid
    redirect_to @event
  rescue Operations::Event::UpdateUserFollow::UserIsBackstage
    redirect_to @event
  end

  def add_user
    @event = find_event
    authorize! @event
    @user = find_user

    Operations::Event::UpdateUserRole.new(event: @event, user: @user, role: params[:role]).perform!
    redirect_to event_event_follows_url(@event), notice: 'Added User.'
  rescue ActiveRecord::RecordInvalid
    redirect_to event_event_follows_url(@event)
  rescue Operations::Event::UpdateUserRole::UserIsOwner
    redirect_to edit_event_owner_url(@event)
  end

  def change_user
    @event = find_event
    authorize! @event
    @user = find_user

    Operations::Event::UpdateUserRole.new(event: @event, user: @user, role: params[:role]).perform!
    redirect_to event_event_follows_url(@event), notice: 'Changed User.'
  rescue ActiveRecord::RecordInvalid
    redirect_to event_event_follows_url(@event)
  rescue Operations::Event::UpdateUserRole::UserIsOwner
    redirect_to edit_event_owner_url(@event)
  end

  def remove_user
    @event = find_event
    authorize! @event
    @user = find_user

    Operations::Event::UpdateUserRole.new(event: @event, user: @user, role: nil).perform!
    redirect_to event_event_follows_url(@event), notice: 'Changed User.'
  rescue ActiveRecord::RecordInvalid
    redirect_to event_event_follows_url(@event)
  rescue Operations::Event::UpdateUserRole::UserIsOwner
    redirect_to edit_event_owner_url(@event)
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
      :hashtag, :platform_id, :category_id, :visibility,
      :capacity, :default_audience_role
    )
  end

  def update_params
    params.require(:event).permit(
      :name, :fullname,
      :description, :organizer_name, :primary_sns, :info_url,
      :hashtag, :platform_id, :category_id,
      :capacity, :default_audience_role
    )
  end

  def event_flavors_params
    params['event_flavors'] || []
  end
end

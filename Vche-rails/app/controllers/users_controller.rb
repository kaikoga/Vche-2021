class UsersController < ApplicationController::Bootstrap
  skip_before_action :require_login, only: [:index, :new, :create]

  def index
    @users = User.page(params[:page])
    authorize!
  end

  def show
    year = show_params[:year]&.to_i
    month = show_params[:month]&.to_i

    @user = find_user
    authorize! @user
    @calendar = CalendarPresenter.new(@user.following_events.invite_or_over, user: @user, year: year, month: month, months: 1, days: 0)
  end

  def info
    @user = find_user
    authorize! @user
  end

  def events
    @user = find_user
    authorize! @user

    @backstage_events = @user.backstage_events.shared_or_over
    @audience_events = @user.audience_events.shared_or_over.page(params[:page])
  end

  def new
    @user = User.new
    authorize! @user
  end

  def edit
    @user = find_user
    authorize! @user
  end

  def create
    @user = User.new(create_params)
    authorize! @user

    if @user.save
      redirect_to :users, notice: 'User was successfully created'
    else
      render :new
    end
  end

  def update
    @user = find_user
    authorize! @user
    if @user.update(update_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user = find_user
    authorize! @user
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def find_user
    User.friendly.find(params[:id])
  end

  def show_params
    @show_params ||= params.permit(:year, :month)
  end

  def create_params
    params.require(:user).permit(:email, :visibility, :user_role, :display_name, :primary_sns, :profile, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:email, :visibility, :user_role, :display_name, :primary_sns, :profile)
  end
end

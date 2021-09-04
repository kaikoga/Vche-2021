class UsersController < ApplicationController
  skip_before_action :require_login, only: [:index, :new, :create]

  # GET /users
  def index
    @users = User.page(params[:page])
  end

  # GET /users/1
  def show
    @user = find_user
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = find_user
    authorize! @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to :users, notice: 'User was successfully created'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    @user = find_user
    authorize! @user
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
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

  def user_params
    params.require(:user).permit(:email, :visibility, :user_role, :display_name, :primary_sns, :profile)
  end
end

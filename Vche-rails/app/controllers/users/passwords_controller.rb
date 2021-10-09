class Users::PasswordsController < ApplicationController::Bootstrap
  def edit
    @user = find_user
    authorize! @user
  end

  def update
    @user = find_user
    authorize! @user
    if @user.update(user_params)
      redirect_to @user, notice: 'User password was successfully updated.'
    else
      render :edit
    end
  end

  private

  def find_user
    User.friendly.find(params[:user_id])
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end

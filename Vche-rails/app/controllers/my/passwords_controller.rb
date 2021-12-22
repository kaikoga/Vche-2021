class My::PasswordsController < ApplicationController::Bootstrap
  include MyResources

  def edit
    authorize! @user
  end

  def update
    authorize! @user
    if @user.update(user_params)
      redirect_to :home, notice: I18n.t('notice.users/passwords.update.success')
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end

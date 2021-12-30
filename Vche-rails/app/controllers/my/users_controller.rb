class My::UsersController < ApplicationController::Bootstrap
  include MyResources

  def destroy
    authorize!
    Operations::User::Destroy.new(user: current_user).perform!
    redirect_to :root, notice: I18n.t('notice.my/users.destroy.success')
  rescue Operations::User::Destroy::UserIsOwner
    redirect_to my_settings_path
  end
end
